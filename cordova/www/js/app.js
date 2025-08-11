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

class FMEApp {
    constructor() {
        this.fmeHelper = window.VWOHelper;
        this.currentUserInfo = { userId: '', query: '' };
        this.isLoading = false;
        this.isFeatureEnabled = false;
        this.featureModelName = '';
        this.featureBackground = '#ffffff';
        this.featureContent = '';
        this.vwoError = null;
        this.isVwoInitialized = false;
        
        this.defaultBotResponse = `
To reset your password:
1. Open the app and go to the login screen.
2. Tap 'Forgot Password?' below the password field.
3. Enter your registered email address and submit.
4. Check your inbox for a password reset email (it may take a few minutes).
5. Click the link in the email and follow the instructions to create a new password.
6. Return to the app and log in with your new password.
        `;
        
        this.initializeApp();
    }

    async initializeApp() {
        try {
            // Enable inputs immediately for browser mode
            if (typeof cordova === 'undefined') {
                this.enableInputs();
            }

            // Set a timeout to ensure inputs are enabled even if Cordova takes too long
            setTimeout(() => {
                this.enableInputs();
            }, 3000); // 3 seconds timeout

            // Wait for Cordova to be ready
            document.addEventListener('deviceready', async () => {
                await this.setupApp();
            }, false);

            // For browser testing
            if (typeof cordova === 'undefined') {
                await this.setupApp();
            }
        } catch (error) {
            console.error('Failed to initialize app:', error);
            // Ensure inputs are enabled even if there's an error
            this.enableInputs();
        }
    }

                    async setupApp() {
                    try {
                        // Check if configuration is available (should be loaded by config.js)
                        if (!window.FME_CONFIG || !window.FME_CONFIG.FME_SDK_KEY || window.FME_CONFIG.FME_SDK_KEY === '') {
                            this.showError('Missing FME Configuration\n\nPlease run generate-config.sh to load configuration from env file.');
                            return;
                        }
                        
                        // Initialize FME
                        const fmeInitialized = await this.fmeHelper.initVwo();
                        
                        if (!fmeInitialized) {
                            this.showError('VWO SDK Initialization Failed\n\nPlease check your FME_SDK_KEY and FME_ACCOUNT_ID in the env file.');
                            return;
                        }

                        this.isVwoInitialized = true;
                        this.showLogsRow();
                        
                        // Setup UI event listeners
                        this.setupEventListeners();
                        
                        // Load initial data
                        this.loadInitialData();
                        
                        // Ensure inputs are enabled
                        this.enableInputs();
                    } catch (error) {
                        console.error('Failed to setup app:', error);
                        this.showError('Failed to initialize FME: ' + error.message);
                        // Ensure inputs are enabled even if there's an error
                        this.enableInputs();
                    }
                }

    setupEventListeners() {
        // Send button
        const sendButton = document.getElementById('sendButton');
        if (sendButton) {
            sendButton.addEventListener('click', () => this.onSendClick());
        }

        // Assign random ID button
        const assignButton = document.getElementById('assignButton');
        if (assignButton) {
            assignButton.addEventListener('click', () => this.onAssignClick());
        }

        // Show logs button
        const showLogsButton = document.getElementById('showLogs');
        if (showLogsButton) {
            showLogsButton.addEventListener('click', () => this.openLogs());
        }

        // Input fields for real-time updates
        const userIdInput = document.getElementById('userId');
        const queryInput = document.getElementById('searchQuery');
        
        if (userIdInput) {
            userIdInput.addEventListener('input', (e) => {
                this.currentUserInfo.userId = e.target.value;
                this.updateUserIdBottom();
            });
        }
        
        if (queryInput) {
            queryInput.addEventListener('input', (e) => {
                this.currentUserInfo.query = e.target.value;
            });
        }
    }

    loadInitialData() {
        // Set initial empty state
        this.currentUserInfo = { userId: '', query: '' };
        this.updateUI();
        this.enableInputs();
    }

    enableInputs() {
        const userIdInput = document.getElementById('userId');
        const queryInput = document.getElementById('searchQuery');
        const assignButton = document.getElementById('assignButton');
        const sendButton = document.getElementById('sendButton');

        if (userIdInput) {
            userIdInput.disabled = false;
            userIdInput.removeAttribute('disabled');
        }
        if (queryInput) {
            queryInput.disabled = false;
            queryInput.removeAttribute('disabled');
        }
        if (assignButton) {
            assignButton.disabled = false;
            assignButton.removeAttribute('disabled');
        }
        if (sendButton) {
            sendButton.disabled = false;
            sendButton.removeAttribute('disabled');
        }
        

    }

    disableInputs() {
        const userIdInput = document.getElementById('userId');
        const queryInput = document.getElementById('searchQuery');
        const assignButton = document.getElementById('assignButton');
        const sendButton = document.getElementById('sendButton');

        if (userIdInput) userIdInput.disabled = true;
        if (queryInput) queryInput.disabled = true;
        if (assignButton) assignButton.disabled = true;
        if (sendButton) sendButton.disabled = true;
    }

    async onSendClick() {
        const userId = document.getElementById('userId').value.trim();
        const query = document.getElementById('searchQuery').value.trim();

        // Validation check for empty fields
        if (!userId || !query) {
            this.showError('Missing Information\n\nPlease enter both User ID and Query.');
            return;
        }
        
        if (!this.isLoading && query && this.isVwoInitialized && userId) {
            this.isLoading = true;
            this.setLoading(true);
            
            // Update current user info
            this.currentUserInfo = { userId, query };
            this.updateUserIdBottom();

            try {
                // Send event
                await this.fmeHelper.trackEvent(userId);

                // Process query
                const response = await this.fmeHelper.processChatQuery(userId, query);
                
                // Update UI with response
                this.updateResponseUI(response);
                
            } catch (error) {
                console.error('Error processing query:', error);
                this.showError('Failed to process your query. Please try again.');
                this.setFallbackResponse();
            } finally {
                this.isLoading = false;
                this.setLoading(false);
            }
        }
    }

    onAssignClick() {
        if (!this.isLoading) {
            const randomUserId = this.generateRandomUserId();
            const randomQuery = this.generateRandomQuery();
            
            this.currentUserInfo = { userId: randomUserId, query: randomQuery };
            
            // Update UI
            document.getElementById('userId').value = randomUserId;
            document.getElementById('searchQuery').value = randomQuery;
            this.updateUserIdBottom();
            

        }
    }

    generateRandomUserId() {
        const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        let userId = '';
        for (let i = 0; i < 12; i++) {
            const randomIndex = Math.floor(Math.random() * letters.length);
            userId += letters[randomIndex];
        }
        return userId;
    }

    generateRandomQuery() {
        return 'I forgot my password';
    }

    updateResponseUI(response) {
        this.isFeatureEnabled = response.isEnabled;
        this.featureModelName = response.model || '';
        this.featureBackground = response.background || '#ffffff';
        this.featureContent = response.content || this.defaultBotResponse;

        // Update powered by section
        const poweredBySection = document.getElementById('poweredBySection');
        const poweredByValue = document.getElementById('poweredByValue');
        
        if (this.featureModelName) {
            poweredByValue.textContent = this.featureModelName;
            poweredBySection.style.display = 'block';
        } else {
            poweredBySection.style.display = 'none';
        }

        // Update content card
        const contentCard = document.getElementById('contentCard');
        const contentText = document.getElementById('contentText');
        
        if (this.featureContent) {
            contentText.textContent = this.featureContent;
            contentCard.style.display = 'block';
            contentCard.style.backgroundColor = this.featureBackground;
        } else {
            contentCard.style.display = 'none';
        }

        // Update status values
        const featureFlagStatus = document.getElementById('featureFlagStatus');
        if (featureFlagStatus) {
            featureFlagStatus.textContent = this.isFeatureEnabled ? 'Enabled' : 'Disabled';
            featureFlagStatus.className = 'status-value ' + (this.isFeatureEnabled ? 'enabled' : 'disabled');
        }

        // Hide loading and error
        this.hideLoading();
        this.hideError();
    }

    setFallbackResponse() {
        this.isFeatureEnabled = false;
        this.featureModelName = '';
        this.featureBackground = '#ffffff';
        this.featureContent = this.defaultBotResponse;

        // Update UI
        const poweredBySection = document.getElementById('poweredBySection');
        const contentCard = document.getElementById('contentCard');
        const contentText = document.getElementById('contentText');
        const featureFlagStatus = document.getElementById('featureFlagStatus');

        poweredBySection.style.display = 'none';
        contentText.textContent = this.featureContent;
        contentCard.style.display = 'block';
        contentCard.style.backgroundColor = this.featureBackground;
        
        if (featureFlagStatus) {
            featureFlagStatus.textContent = 'Disabled';
            featureFlagStatus.className = 'status-value disabled';
        }
    }

    updateUserIdBottom() {
        const userIdBottom = document.getElementById('userIdBottom');
        if (userIdBottom) {
            userIdBottom.textContent = this.getDisplayUserId();
        }
    }

    getDisplayUserId() {
        const userId = this.currentUserInfo.userId;
        return userId.length > 8 ? `${userId.substring(0, 8)}...` : userId;
    }

    updateUI() {
        this.updateUserIdBottom();
        
        // Reset response section
        const poweredBySection = document.getElementById('poweredBySection');
        const contentCard = document.getElementById('contentCard');
        const featureFlagStatus = document.getElementById('featureFlagStatus');

        if (poweredBySection) poweredBySection.style.display = 'none';
        if (contentCard) contentCard.style.display = 'none';
        if (featureFlagStatus) {
            featureFlagStatus.textContent = '-';
            featureFlagStatus.className = 'status-value';
        }
    }

    setLoading(isLoading) {
        const sendButton = document.getElementById('sendButton');
        const sendSpinner = document.getElementById('sendSpinner');
        const sendText = document.getElementById('sendText');
        
        if (isLoading) {
            this.disableInputs();
            if (sendSpinner) sendSpinner.style.display = 'inline-block';
            if (sendText) sendText.style.display = 'none';
            this.showLoading();
        } else {
            this.enableInputs();
            if (sendSpinner) sendSpinner.style.display = 'none';
            if (sendText) sendText.style.display = 'inline';
            this.hideLoading();
        }
    }

    showLoading() {
        const loadingContainer = document.getElementById('loadingContainer');
        if (loadingContainer) loadingContainer.style.display = 'flex';
    }

    hideLoading() {
        const loadingContainer = document.getElementById('loadingContainer');
        if (loadingContainer) loadingContainer.style.display = 'none';
    }

    showError(message) {
        const errorMessage = document.getElementById('errorMessage');
        const errorText = document.getElementById('errorText');
        
        if (errorMessage && errorText) {
            errorText.textContent = message;
            errorMessage.style.display = 'block';
        }
    }

    hideError() {
        const errorMessage = document.getElementById('errorMessage');
        if (errorMessage) errorMessage.style.display = 'none';
    }

    showLogsRow() {
        const logsRow = document.getElementById('logsRow');
        if (logsRow) {
            logsRow.style.display = 'flex';
        }
    }

    openLogs() {
        const logs = this.fmeHelper.getLogs();
        this.showModal('FME Logs', logs);
    }

    showModal(title, content) {
        // Create modal HTML
        const modalHTML = `
            <div id="logsModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">${title}</h3>
                        <span class="close">&times;</span>
                    </div>
                    <div class="logs-content" id="logsContent">
                        <div class="no-logs-message"><p>Loading logs...</p></div>
                    </div>
                </div>
            </div>
        `;

        // Add modal to page
        document.body.insertAdjacentHTML('beforeend', modalHTML);

        const modal = document.getElementById('logsModal');
        const logsContent = document.getElementById('logsContent');
        const closeBtn = modal.querySelector('.close');

        // Format and set content
        const formattedContent = content ? this.formatLogs(content) : '<div class="no-logs-message"><p>No logs available yet. SDK logs will appear here after initialization and interactions.</p></div>';
        
        logsContent.innerHTML = formattedContent;

        // Show modal
        modal.style.display = 'block';

        // Close modal when clicking X
        closeBtn.onclick = () => {
            modal.remove();
        };

        // Close modal when clicking outside
        modal.onclick = (event) => {
            if (event.target === modal) {
                modal.remove();
            }
        };
    }

    formatLogs(logs) {
        if (!logs || logs.trim() === '') {
            return '<div class="no-logs-message"><p>No logs available yet. SDK logs will appear here after initialization and interactions.</p></div>';
        }

        const logLines = logs.split('\n');
        
        const formattedLogs = logLines.map((line, index) => {
            if (!line.trim()) {
                return '';
            }
            
            // Parse timestamp and level
            const timestampMatch = line.match(/^\[([^\]]+)\]/);
            const levelMatch = line.match(/\[(INFO|WARN|ERROR|DEBUG|debug)\]/);
            
            if (timestampMatch && levelMatch) {
                const timestamp = timestampMatch[1];
                const level = levelMatch[1];
                const message = line.replace(/^\[[^\]]+\]\s*\[[^\]]+\]\s*/, '');
                
                const logEntry = `<div class="log-entry">
                        <div class="log-timestamp">${timestamp}</div>
                        <div class="log-message log-${level.toLowerCase()}">[${level}] ${message}</div>
                    </div>`;
                return logEntry;
            } else {
                return `<div class="log-entry"><div class="log-message">${line}</div></div>`;
            }
        }).filter(entry => entry.trim() !== '').join('');
        
        return formattedLogs;
    }
}

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.fmeApp = new FMEApp();
    
    // Ensure inputs are enabled after a short delay
    setTimeout(() => {
        if (window.fmeApp) {
            window.fmeApp.enableInputs();
        }
    }, 100);
}); 