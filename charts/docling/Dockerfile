# Use the same base image as the original docling Dockerfile
FROM python:3.11-slim-bookworm

# Set the working directory
WORKDIR /app

# Install system dependencies, same as the original docling Dockerfile
RUN apt-get update \
    && apt-get install -y libgl1 libglib2.0-0 curl wget git procps \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY main.py .

# Download docling models, as in the original Dockerfile
RUN docling-tools models download

# Set environment variables, as in the original Dockerfile
ENV HF_HOME=/tmp/
ENV TORCH_HOME=/tmp/
ENV OMP_NUM_THREADS=4

# Expose the port the app runs on
EXPOSE 8000

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
