import g4f
import asyncio
from flask import Flask, request, jsonify
import torch
import torchvision.transforms as transforms
import torchvision.models as models
import torch.nn as nn
from pathlib import Path
from PIL import Image
import json
import sys
import logging
from flask_cors import CORS

# Configure g4f
g4f.debug.logging = True  # Enable verbose logging
g4f.check_version = False  # Disable version checks
logger = logging.getLogger(__name__)

# Configure Flask
app = Flask(__name__)
CORS(app)
logging.basicConfig(level=logging.DEBUG)

# Windows event loop fix
if sys.platform == 'win32':
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
@app.route('/')
def home():
    return "This is the API for RoadCrackDetection"
# # Load crack detection model
def load_crack_model():
    model_dir = Path("saved_model")
    
    with open(model_dir / 'class_labels.json') as f:
        class_labels = json.load(f)
    
    with open(model_dir / 'transform_config.json') as f:
        transform_config = json.load(f)

    transformations = transforms.Compose([
        transforms.Resize(transform_config['resize']),
        transforms.CenterCrop(transform_config['crop']),
        transforms.ToTensor(),
        transforms.Normalize(transform_config['mean'], transform_config['std'])
    ])

    model = models.densenet161(pretrained=False)
    model.classifier = nn.Sequential(
        nn.Linear(model.classifier.in_features, 64),
        nn.ReLU(),
        nn.Linear(64, 32),
        nn.ReLU(),
        nn.Linear(32, len(class_labels)),
        nn.LogSoftmax(dim=1)
    )
    
    checkpoint = torch.load(model_dir / 'model_state.pth', map_location='cpu')
    model.load_state_dict(checkpoint['model_state_dict'])
    model.eval()
    
    return model, transformations, class_labels


model, transformations, class_labels = load_crack_model()

CRACK_TYPES = {
    "D00": "Longitudinal Crack (Wheel Mark Part)",
    "D01": "Longitudinal Crack (Construction Joint)",
    "D10": "Transverse Crack (Equal Interval)",
    "D11": "Transverse Crack (Construction Joint)",
    "D20": "Alligator Crack",
    "D40": "Pothole/Rutting",
    "D43": "White Line Blur",
    "D44": "Crosswalk Blur"
}

async def get_crack_remedy(crack_info: dict) -> str:
    """Get repair suggestions using automatic provider selection"""
    try:
        prompt = (
            f"Provide a civil engineering solution for {crack_info['name']} - "
            f"{crack_info['description']}. Include:\n"
            "- Materials needed\n- Step-by-step repair procedure\n"
            "- Safety precautions\n- Cost estimation\n"
            "- Expected durability\n\n"
            "Format in clear paragraphs without markdown."
        )
        
        response = await g4f.ChatCompletion.create_async(
            model=g4f.models.gpt_4,
            messages=[{"role": "user", "content": prompt}],
            timeout=30
        )
        
        return response if isinstance(response, str) else "\n".join(response)
        
    except Exception as e:
        logger.error(f"Remedy error: {str(e)}")
        return f"Could not generate solution: {str(e)}"

@app.route('/predict', methods=['POST'])
def predict():
    """Handle crack detection requests"""
    try:
        if 'file' not in request.files:
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files['file']
        img = Image.open(file).convert('RGB')
        tensor = transformations(img).unsqueeze(0)
        
        with torch.no_grad():
            output = model(tensor)
            probs = torch.exp(output)
            conf, cls_idx = probs.topk(1, dim=1)
        
        crack_id = class_labels[cls_idx.item()]
        crack_data = {
            "name": CRACK_TYPES.get(crack_id, "Unknown Crack"),
            "description": "Horizontal cracks at construction joints"  # Add your descriptions
        }
        
        remedy = asyncio.run(get_crack_remedy(crack_data))
        
        return jsonify({
            "crack_type": crack_data["name"],
            "confidence": round(float(conf.item()), 4),
            "remedy": remedy
        })
        
    except Exception as e:
        logger.error(f"Prediction failed: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    
    app.run(host='0.0.0.0', port=5000, debug=False)  # Debugger disabled

