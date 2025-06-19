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

class DashboardViewModel: ObservableObject {
    
    @Published var isFeatureEnabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var isInitialized: Bool = false
    @Published var userId: String = generateRandomUserId()
    @Published var error: String? = nil
    @Published var playButtonColor: String = "#E50914"
    @Published var isWatchListEnabled: Bool = false
    @Published var posterPortrait: Bool = true
    
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
                
                if self.isFeatureEnabled {
                    
                    if let playButtonColor = flag.getVariable(key: Constants.FeatureFlags.variableKey1, defaultValue: "#E50914") as? String {
                        self.playButtonColor = playButtonColor
                    }
                    
                    if let isWatchListEnabled = flag.getVariable(key: Constants.FeatureFlags.variableKey2, defaultValue: false) as? Bool {
                        self.isWatchListEnabled = isWatchListEnabled
                    }
                    
                    if let posterPortrait = flag.getVariable(key: Constants.FeatureFlags.variableKey3, defaultValue: true) as? Bool {
                        self.posterPortrait = posterPortrait
                    }
                }
                self.isLoading = false
            }
        }
    }
    
    // Track user interaction
    func trackPlayButtonInteraction(isWatchListEnabled: Bool) {
        guard isInitialized else {
            error = "Cannot track event: SDK not initialized"
            return
        }
        
        let properties: [String: Any] = ["watchListEnabled": isWatchListEnabled]
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
