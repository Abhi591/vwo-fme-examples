/*
 * Copyright (c) 2024-2025 Wingify Software Pvt. Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

let vwoClient = null;
let vwoLogs = [];

// Initialize VWO SDK
async function initVwo() {
    try {
        // Check if VWO SDK is available
        if (typeof vwoSdk === 'undefined') {
            throw new Error('VWO SDK not loaded. Please check your internet connection and try again.');
        }
        
        // Get configuration from config.js
        const config = window.FME_CONFIG;
        
        if (!config || !config.FME_SDK_KEY || !config.FME_ACCOUNT_ID) {
            throw new Error('Missing required VWO configuration. Please set FME_SDK_KEY and FME_ACCOUNT_ID in your env file.');
        }

        vwoClient = await vwoSdk.init({
            accountId: config.FME_ACCOUNT_ID,
            sdkKey: config.FME_SDK_KEY,
            logger: {
                level: 'DEBUG',
                transport: {
                    log: (level, message) => {
                        vwoLogs.push({ level, message, timestamp: new Date().toISOString() });
                    },
                },
            },
            integrations: {
                callback: (properties) => {
                },
            },
            pollInterval: 120000, // 2 minutes
        });
        
        // Add a test log entry
        vwoLogs.push({ 
            level: 'INFO', 
            message: 'VWO FME SDK initialized successfully', 
            timestamp: new Date().toISOString() 
        });
        
        window.vwoClient = vwoClient;
        return true;
    } catch (error) {
        console.error('Failed to initialize VWO FME SDK:', error);
        return false;
    }
}

// Get flag and track event
async function getVwoFlagAndTrack(userId, query) {
    if (!window.vwoClient) {
        throw new Error('VWO SDK not initialized');
    }

    const config = window.FME_CONFIG;
    const userContext = {
        id: userId,
        customVariables: config.customVariables || {}
    };

    try {
        // Get the flag
        const flag = await window.vwoClient.getFlag(config.FLAG_NAME, userContext);
        const isEnabled = flag.isEnabled();
        
        // Get variables
        const variables = flag.getVariables();
        const modelName = flag.getVariable(config.VARIABLE_1_KEY, '');
        const queryAnswer = flag.getVariable(config.VARIABLE_2_KEY, { 
            background: '#ffffff', 
            content: 'Default response content' 
        });

        // Extract content and background from queryAnswer object
        let content, background;
        if (isEnabled) {
            // Flag is enabled - use VWO content
            if (typeof queryAnswer === 'object' && queryAnswer !== null) {
                content = queryAnswer.content || 'Default response content';
                background = queryAnswer.background || '#ffffff';
            } else {
                // Fallback if queryAnswer is not an object
                content = queryAnswer || 'Default response content';
                background = flag.getVariable(config.VARIABLE_2_BG, '#ffffff');
            }
        } else {
            // Flag is disabled - show password reset instructions
            content = `To reset your password:
1. Open the app and go to the login screen.
2. Tap 'Forgot Password?' below the password field.
3. Enter your registered email address and submit.
4. Check your inbox for a password reset email (it may take a few minutes).
5. Click the link in the email and follow the instructions to create a new password.
6. Return to the app and log in with your new password.`;
            background = '#ffffff';
        }

        // Track the event
        await window.vwoClient.trackEvent(config.EVENT_NAME, userContext);

        // Add logs for the operation
        vwoLogs.push({ 
            level: 'INFO', 
            message: `Flag evaluation completed - Enabled: ${isEnabled}, Model: ${modelName}`, 
            timestamp: new Date().toISOString() 
        });

        return {
            isEnabled,
            model: modelName,
            content: content,
            background: background,
            variables: variables,
            logs: vwoLogs
        };
    } catch (error) {
        console.error('Error getting flag or tracking event:', error);
        throw error;
    }
}

// Get logs
function getVwoLogs() {
    const formattedLogs = vwoLogs.map(log => 
        `[${log.timestamp}] [${log.level}] ${log.message}`
    ).join('\n');
    
    return formattedLogs;
}

// Clear logs
function clearVwoLogs() {
    vwoLogs = [];
}

// Initialize VWO when DOM is ready
// VWO initialization is now controlled by the app, not automatic

// Process chat query using VWO FME
async function processChatQuery(userId, query) {
    try {
        const config = window.FME_CONFIG;
        
        // Get flag and track event
        const result = await getVwoFlagAndTrack(userId, query);
        
        return {
            success: true,
            isEnabled: result.isEnabled,
            model: result.model,
            background: result.background,
            content: result.content
        };
    } catch (error) {
        console.error('Error processing chat query:', error);
        return {
            success: false,
            response: 'Sorry, there was an error processing your request.',
            modelName: 'error-model',
            background: '#ffffff',
            content: 'Error content'
        };
    }
}

// Track event
async function trackEvent(userId) {
    try {
        const config = window.FME_CONFIG;
        if (!vwoClient) {
            console.warn('VWO client not initialized');
            return false;
        }

        const eventName = config.EVENT_NAME || 'aiModelInteracted';
        const result = vwoClient.trackEvent(eventName, {
            userId: userId,
            timestamp: new Date().toISOString()
        });


        return true;
    } catch (error) {
        console.error('Error tracking event:', error);
        return false;
    }
}

// Get logs (alias for getVwoLogs)
function getLogs() {
    return getVwoLogs();
}

// Export functions for use in app.js
window.VWOHelper = {
    initVwo,
    getVwoFlagAndTrack,
    processChatQuery,
    trackEvent,
    getLogs,
    getVwoLogs,
    clearVwoLogs
};