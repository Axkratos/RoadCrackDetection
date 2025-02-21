# Use a lightweight Python base image
FROM python:3.9-slim-buster

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependencies
COPY requirements.txt . 

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . .

# Expose the application's port
EXPOSE 5000

# Run the application using Waitress
CMD ["python", "-m", "waitress", "--listen=0.0.0.0:5000", "--call=app:create_app"]
