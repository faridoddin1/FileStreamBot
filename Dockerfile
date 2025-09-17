# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Install system dependencies required by tgcrypto
# build-essential includes C compilers, and libssl-dev is for OpenSSL
RUN apt-get update && apt-get install -y build-essential libssl-dev

# Set the working directory in the container
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application's code
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Define the command to run the application
CMD ["python3", "-m", "WebStreamer"]
