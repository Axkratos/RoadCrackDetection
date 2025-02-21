# Use a lightweight Python image
FROM python:3.9-slim-buster

# Set working directory
WORKDIR /app

# Install system dependencies required for PyTorch and OpenCV
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file first (for better Docker caching)
COPY requirements.txt . 

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire application code
COPY . .

# Expose the application port
EXPOSE 5000

# Run the application using Waitress
CMD ["python", "-m", "waitress", "--listen=0.0.0.0:5000", "--call=app:create_app", "--threads=4", "--timeout=300"]
