from PIL import Image
import io
import torchvision.transforms as transforms

def process_image(image_bytes):
    image = Image.open(io.BytesIO(image_bytes))
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
    ])
    return transform(image).unsqueeze(0)