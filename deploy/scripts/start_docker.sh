#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 484907528890.dkr.ecr.eu-north-1.amazonaws.com

echo "Pulling Docker image..."
docker pull 484907528890.dkr.ecr.eu-north-1.amazonaws.com/delivery-time-prediction:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=delivery_time_pred)" ]; then
    echo "Stopping existing container..."
    docker stop delivery_time_pred
fi

if [ "$(docker ps -aq -f name=delivery_time_pred)" ]; then
    echo "Removing existing container..."
    docker rm delivery_time_pred
fi

echo "Starting new container..."
docker run -d -p 80:8000 --name delivery_time_pred -e DAGSHUB_USER_TOKEN=d13d726e3f6c838cce3e4922d7c7fd6ac5b2bf0d 484907528890.dkr.ecr.eu-north-1.amazonaws.com/delivery-time-prediction:latest

echo "Container started successfully."