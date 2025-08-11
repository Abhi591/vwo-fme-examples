#!/bin/bash

echo "🔧 Generating config.js from .env file..."

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found"
    echo "💡 Please create a .env file: cp .env.example .env"
    exit 1
fi

# Read env file and set default values
FME_ACCOUNT_ID=0
FME_SDK_KEY=""
FLAG_NAME=""
EVENT_NAME=""
VARIABLE_1_KEY=""
VARIABLE_2_KEY=""
VARIABLE_2_CONTENT=""
VARIABLE_2_BG="#ffffff"
MAX_LOG_MESSAGES=200
MIXPANEL_PROJECT_TOKEN=""
SEGMENT_WRITE_KEY=""

# Parse .env file
while IFS='=' read -r key value || [ -n "$key" ]; do
    # Skip empty lines and comments
    if [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # Remove leading/trailing whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    
    # Set variables based on key
    case "$key" in
        "FME_ACCOUNT_ID") FME_ACCOUNT_ID="$value" ;;
        "FME_SDK_KEY") FME_SDK_KEY="$value" ;;
        "FLAG_NAME") FLAG_NAME="$value" ;;
        "EVENT_NAME") EVENT_NAME="$value" ;;
        "VARIABLE_1_KEY") VARIABLE_1_KEY="$value" ;;
        "VARIABLE_2_KEY") VARIABLE_2_KEY="$value" ;;
        "VARIABLE_2_CONTENT") VARIABLE_2_CONTENT="$value" ;;
        "VARIABLE_2_BG") VARIABLE_2_BG="$value" ;;
        "MAX_LOG_MESSAGES") MAX_LOG_MESSAGES="$value" ;;
        "MIXPANEL_PROJECT_TOKEN") MIXPANEL_PROJECT_TOKEN="$value" ;;
        "SEGMENT_WRITE_KEY") SEGMENT_WRITE_KEY="$value" ;;
    esac
done < ".env"

echo "📝 Found configuration values:"
echo "- FME_ACCOUNT_ID: $FME_ACCOUNT_ID"
echo "- FME_SDK_KEY: $([ -n "$FME_SDK_KEY" ] && echo "Set" || echo "Not set")"
echo "- FLAG_NAME: $FLAG_NAME"
echo "- EVENT_NAME: $EVENT_NAME"

# Generate config.js file
cat > "www/js/config.js" << EOF
// Configuration values loaded from .env file at build time
const FME_CONFIG = {
    FME_ACCOUNT_ID: $FME_ACCOUNT_ID,
    FME_SDK_KEY: '$FME_SDK_KEY',
    FLAG_NAME: '$FLAG_NAME',
    EVENT_NAME: '$EVENT_NAME',
    VARIABLE_1_KEY: '$VARIABLE_1_KEY',
    VARIABLE_2_KEY: '$VARIABLE_2_KEY',
    VARIABLE_2_CONTENT: '$VARIABLE_2_CONTENT',
    VARIABLE_2_BG: '$VARIABLE_2_BG',
    MAX_LOG_MESSAGES: $MAX_LOG_MESSAGES,
    MIXPANEL_PROJECT_TOKEN: '$MIXPANEL_PROJECT_TOKEN',
    SEGMENT_WRITE_KEY: '$SEGMENT_WRITE_KEY',
    customVariables: {}
};

// Export configuration for immediate use
window.FME_CONFIG = FME_CONFIG;
EOF

echo "✅ Successfully generated www/js/config.js"
echo "🚀 Configuration values are now embedded directly in config.js"