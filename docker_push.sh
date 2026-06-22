#!/bin/bash

USERNAME=$(zenity --entry \
--title="Docker Login" \
--text="Enter Docker Username")

PASSWORD=$(zenity --password \
--title="Docker Login")

echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin

if [ $? -ne 0 ]; then
    zenity --error --text="Docker Login Failed"
    exit 1
fi

IMAGE_NAME=$(zenity --entry \
--title="Docker Image" \
--text="Enter Image Name")

DOCKERFILE=$(zenity --file-selection \
--title="Select Dockerfile")

BUILD_DIR=$(dirname "$DOCKERFILE")

docker build -t $IMAGE_NAME $BUILD_DIR

docker tag $IMAGE_NAME $USERNAME/$IMAGE_NAME:latest

docker push $USERNAME/$IMAGE_NAME:latest

if [ $? -eq 0 ]; then
    zenity --info \
    --text="Docker Image Pushed Successfully"
else
    zenity --error \
    --text="Docker Push Failed"
fi
