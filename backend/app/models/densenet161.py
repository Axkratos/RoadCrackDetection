import torch
import torchvision.models as models

def load_model():
    model = models.densenet161(pretrained=True)
    model.eval()
    return model

def predict_crack(model, image_tensor):
    with torch.no_grad():
        outputs = model(image_tensor)
        _, predicted = torch.max(outputs, 1)
    return predicted.item()