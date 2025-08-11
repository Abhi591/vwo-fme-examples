#!/bin/bash

echo "Setting up VWO FME Cordova Application..."

# Check if Cordova CLI is installed
if ! command -v cordova &> /dev/null; then
    echo "Error: Cordova CLI is not installed. Please install it first:"
    echo "npm install -g cordova"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install it first."
    exit 1
fi

echo "Installing dependencies..."
npm install

echo "Adding platforms..."
cordova platform add android
cordova platform add ios
cordova platform add browser

echo "Installing plugins..."
cordova plugin add cordova-plugin-device
cordova plugin add cordova-plugin-whitelist
cordova plugin add cordova-plugin-splashscreen
cordova plugin add cordova-plugin-statusbar
cordova plugin add cordova-plugin-inappbrowser
cordova plugin add cordova-plugin-file
cordova plugin add cordova-plugin-network-information

echo "Setting up environment file..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Created .env file from template. Please edit it with your VWO FME credentials."
else
    echo ".env file already exists."
fi

# Generate initial config.js
echo "Generating initial config.js..."
./generate-config.sh

echo "Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Edit the .env file with your VWO FME credentials"
echo "2. Run './generate-config.sh' after editing .env file"
echo "3. Run 'cordova run browser' to test in browser"
echo "4. Run 'cordova run android' to test on Android"
echo "5. Run 'cordova run ios' to test on iOS (macOS only)" 