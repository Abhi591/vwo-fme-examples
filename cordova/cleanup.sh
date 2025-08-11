#!/bin/bash

echo "Cleaning up Cordova project to resolve plugin migration issues..."

# Remove platforms and plugins directories
echo "Removing platforms and plugins directories..."
rm -rf platforms/
rm -rf plugins/

# Remove node_modules and reinstall
echo "Removing node_modules and reinstalling dependencies..."
rm -rf node_modules/
npm install

# Re-add platforms
echo "Re-adding platforms..."
cordova platform add android
cordova platform add ios
cordova platform add browser

# Re-add plugins
echo "Re-adding plugins..."
cordova plugin add cordova-plugin-device
cordova plugin add cordova-plugin-whitelist
cordova plugin add cordova-plugin-splashscreen
cordova plugin add cordova-plugin-statusbar
cordova plugin add cordova-plugin-inappbrowser
cordova plugin add cordova-plugin-file
cordova plugin add cordova-plugin-network-information

echo "Cleanup completed successfully!"
echo ""
echo "The project has been cleaned up and plugins have been properly installed."
echo "You can now run:"
echo "- cordova run browser"
echo "- cordova run android"
echo "- cordova run ios" 