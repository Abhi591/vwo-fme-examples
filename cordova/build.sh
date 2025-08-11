#!/bin/bash

echo "Building VWO FME Cordova Application..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Warning: .env file not found. Please create it from .env.example"
    echo "cp .env.example .env"
    exit 1
fi

# Generate config.js from .env file
echo "Generating config.js from .env file..."
./generate-config.sh

# Build for all platforms
echo "Building for browser..."
cordova build browser

echo "Building for Android..."
cordova build android

echo "Building for iOS..."
cordova build ios

echo "Build completed successfully!"
echo ""
echo "Build outputs:"
echo "- Browser: platforms/browser/www/"
echo "- Android: platforms/android/app/build/outputs/apk/"
echo "- iOS: platforms/ios/build/" 