# Anugaman - Road Crack Detection System

Anugaman is a Flutter-based mobile application designed to detect road cracks using AI-powered image analysis. This project integrates a machine learning model with a user-friendly mobile interface to provide instant diagnosis of road surface defects, offering repair solutions to enhance road safety and maintenance.

## 🚀 Problem Statement

Road infrastructure maintenance is crucial for safety and efficiency. Traditional methods of road inspection are time-consuming, labor-intensive, and often subjective. Anugaman aims to:

- **Automate Road Inspection**: Use AI to detect cracks and defects in road surfaces quickly and accurately.
- **Provide Repair Solutions**: Offer immediate repair recommendations to address identified issues.
- **Improve Safety**: Enhance road safety by identifying potential hazards before they become critical.

## 🛠️ How It Solves the Problem

- **AI-Powered Detection**: Utilizes a fine-tuned DenseNet161 model to classify road cracks with high precision.
- **Mobile Interface**: Provides an intuitive Flutter UI for capturing or uploading road images for analysis.
- **Backend Integration**: A FastAPI server handles image uploads, model predictions, and returns results in JSON format.
- **Real-Time Feedback**: Users receive instant feedback on crack types and repair solutions, enabling proactive maintenance.

## 🏗️ Tech Stack

### 📱 Frontend (Flutter)
- **Dart**: Client-optimized programming language for fast apps.
- **Flutter**: Cross-platform UI toolkit for iOS and Android development.
  - Hot reload for quick development cycles.
  - Material Design components for a modern look.

**Libraries Used:**
- `google_fonts` - Custom typography for enhanced UI design.
- `image_picker` - Allows users to capture or select images.
- `http` - For making HTTP requests to the backend.
- `font_awesome_flutter` - Provides a wide range of icons for UI elements.

### 🔥 Backend (FastAPI & Python)
- **Python**: Backend logic, server setup, and model integration.
- **FastAPI**: Modern and high-performance web framework.
  - Asynchronous programming support.
  - Automatic interactive documentation.
  - High performance due to Starlette and Pydantic.

**Libraries Used:**
- `torch` - PyTorch for model loading and inference.
- `torchvision` - For image transformations and dataset handling.
- `g4f` - AI-powered repair solution generation.
- `flask` - Alternative API framework (if needed).
- `waitress` - Production server deployment.

### 🧠 Machine Learning Model (DenseNet161)
- **DenseNet161**: A deep learning model with dense connectivity.
  - Efficient use of parameters and computation.
- **Training Process**:
  - Transfer learning from a pretrained model.
  - Fine-tuned with a custom classifier for road crack classification.
  - Trained on a dataset of road images with various crack types.
- **Evaluation Metrics**:
  - Accuracy, precision, recall, F1-score, and ROC curves.

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🙌 Acknowledgments

- Thanks to the creators of the road crack detection dataset for providing the training data.
- Flutter community for the amazing framework and resources.
- FastAPI for the efficient backend framework.

---

Feel free to reach out if you have any questions or suggestions for improvement! 🚀

