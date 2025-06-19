/**
 * Copyright 2025 Wingify Software Pvt. Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var isFeatureEnabled: Bool = false
    
    @Published var isPlaybackSpeedControlEnabled: Bool = true
    @Published var isSettingEnabled: Bool = true
    @Published var isDarkModeEnabled: Bool = true

    @Published var isLoading: Bool = false
    @Published var isInitialized: Bool = false
    @Published var userId: String = generateRandomUserId()
    @Published var error: String? = nil
    
    // Initialize SDK and fetch feature flags
    func initializeAndFetchFeatureFlags() {
        if isInitialized {
            return
        }
        isLoading = true
        error = nil
        
        // Initialize SDK
        FeatureManager.shared.initSDK() { success in
            if success {
                self.isInitialized = true
                self.fetchFeatureFlags()
                
            } else {
                self.isLoading = false
                self.error = "SDK initialization failed"
            }
        }
    }
    
    // Fetch feature flags
    func fetchFeatureFlags() {
        guard isInitialized else {
            error = "SDK not initialized"
            isLoading = false
            return
        }
        
        error = nil
        
        FeatureManager.shared.getFeatureFlag(feature: Constants.FeatureFlags.fmeExample,
                                             userId: userId) { [weak self] flag in
            
            guard let self = self else {return}
            DispatchQueue.main.async {
                
                // Check if feature is enabled
                self.isFeatureEnabled = flag.isEnabled()
                
                print("Flag variables >>> ", flag.getVariables())
                
                if self.isFeatureEnabled {
                                        
                    if let isPlaybackSpeedControlEnabled = flag.getVariable(key: Constants.FeatureFlags.variableKey1, defaultValue: false) as? Bool {
                        self.isPlaybackSpeedControlEnabled = isPlaybackSpeedControlEnabled
                    }
                    
                    if let isSettingEnabled = flag.getVariable(key: Constants.FeatureFlags.variableKey2, defaultValue: true) as? Bool {
                        self.isSettingEnabled = isSettingEnabled
                    }
                    
                    if let isDarkModeEnabled = flag.getVariable(key: Constants.FeatureFlags.variableKey3, defaultValue: false) as? Bool {
                        self.isDarkModeEnabled = isDarkModeEnabled
                    }
                }
                self.isLoading = false
            }
        }
    }
    
    // Track user interaction
    func trackPlaybackFeaturesUsed() {
        guard isInitialized else {
            error = "Cannot track event: SDK not initialized"
            return
        }
        
        let properties: [String: Any] = ["playbackSpeed": isPlaybackSpeedControlEnabled ? 1 : 0,
                                         "setting": isSettingEnabled ? 1 : 0,
                                         "darkMode": isDarkModeEnabled ? 1 : 0]
        FeatureManager.shared.trackEvent(eventName: Constants.Events.userInteracted,
                                         userId: userId,
                                         eventProperties: properties)
    }

    func showRandomVariation() {
        self.isLoading = true
        self.userId = generateRandomUserId()
        self.fetchFeatureFlags()
    }
    
}
