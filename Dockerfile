# Stage 1: The Builder
# Use the full python image, not slim, as it contains more build tools out-of-the-box
FROM python:3.11 as builder

# Install build dependencies, just in case
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Set up a directory for our wheels
WORKDIR /wheels

# Copy only the requirements file
COPY requirements.txt .

# Download and compile all dependencies into wheels
RUN pip wheel --no-cache-dir --wheel-dir=/wheels -r requirements.txt


# Stage 2: The Final Application Image
# Use the slim image for the final stage to keep it small
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Install the pre-compiled wheels from the builder stage
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels /wheels/*

# Copy the rest of your application's code
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Define the command to run the application
CMD ["python3", "-m", "WebStreamer"]
