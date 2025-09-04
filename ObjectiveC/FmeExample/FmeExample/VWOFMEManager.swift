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
import VWO_FME

/**
 * VWOFMEManager - Swift Wrapper for VWO FME SDK
 * 
 * PURPOSE:
 * This class serves as a comprehensive Swift wrapper for the VWO FME (Feature Management
 * and Experimentation) SDK, providing Objective-C compatible methods for feature flag
 * management, A/B testing, user context management, and event tracking.
 * 
 * KEY FEATURES:
 * - Singleton pattern for global SDK access
 * - VWO FME SDK initialization and configuration
 * - Feature flag retrieval and evaluation
 * - User context creation and management
 * - Event tracking and goal completion
 * - Comprehensive logging system with timestamp formatting
 * - Objective-C interoperability via @objc annotations
 * - LogTransport protocol implementation for SDK logging
 * 
 * ARCHITECTURE:
 * - Inherits from NSObject for Objective-C compatibility
 * - Implements @unchecked Sendable for concurrency safety
 * - Implements LogTransport protocol for SDK logging integration
 * - Uses singleton pattern for global SDK instance management
 * 
 * USAGE:
 * Access via: VWOFMEManager.shared
 * Example: [[VWOFMEManager shared] VWOFMEinitialize]
 * 
 * DEPENDENCIES:
 * - VWO_FME framework
 * - VWOConstants for configuration values
 * 
 */
@objc public class VWOFMEManager: NSObject, @unchecked Sendable , LogTransport {
    
    // MARK: - Singleton & Properties
    
    /**
     * Singleton instance for global access to VWO FME SDK functionality
     * Provides a single point of access for all SDK operations across the app
     */
    @objc public static let shared = VWOFMEManager()
    
    /**
     * Flag indicating whether the VWO FME SDK has been successfully initialized
     * Used to prevent operations before SDK is ready
     */
    var isInitialized: Bool = false
    
    /**
     * Array to store SDK operation logs with timestamps
     * Used for debugging and monitoring SDK operations
     * Accessible from Objective-C for log display
     */
    @objc public var logsSdk: [String] = []
    
    /**
     * Private initializer to enforce singleton pattern
     * Prevents external instantiation of the class
     */
    private override init() {}
    
    // MARK: - SDK Initialization
    
    /**
     * Initializes the VWO FME SDK with configuration options
     * Sets up the SDK for feature flag operations, A/B testing, and user tracking
     * 
     * CONFIGURATION:
     * - SDK Key: Retrieved from VWOConstants
     * - Account ID: Retrieved from VWOConstants
     * - Log Level: Set to debug for development
     * - Log Transport: Self-implemented for custom logging
     * - VWO Meta: Platform identification and version info
     */
    @available(macOS 10.14, *)
    @objc public func VWOFMEinitialize() {
        
        // Create initialization options with configuration from constants
        let options = VWOInitOptions(
            sdkKey: VWOConstants.SDK_KEY,           // VWO account SDK key
            accountId: VWOConstants.ACCOUNT_ID,     // VWO account identifier
            logLevel: .debug,                       // Debug logging for development
            logTransport: self,                     // Custom log transport implementation
            vwoMeta: ["_ea":1, "_ean": "iOS"]      // Platform metadata for analytics
        )
        
        // Initialize VWO FME SDK with the configured options
        VWOFme.initialize(options: options) { result in
            switch result {
            case .success(let message):
                // SDK initialization successful
                print("VWO Initialized: \(message)")
                self.isInitialized = true  // Mark SDK as ready for operations
                
            case .failure(let error):
                // SDK initialization failed
                print("VWO Initialization Failed: \(error)")
            }
        }
    }
    

    // MARK: - User Context Management
    
    /**
     * Creates a VWO user context for feature flag evaluation and personalization
     * User context is essential for targeted feature flags and A/B testing
     * 
     * @param id Optional user identifier for consistent user experience
     * @param customVariables Dictionary of user attributes for targeting (e.g., age, location, plan)
     * @return VWOUserContext object for feature flag operations
     * 
     * USAGE:
     * - Pass user ID for consistent feature flag evaluation
     * - Include custom variables for targeted feature rollouts
     * - Use for all feature flag and event tracking operations
     */
    @objc public func vwoUserContext(id: String? = nil, customVariables: [String: Any] = [:]) -> VWOUserContext {
        // Create VWO user context with provided ID and custom variables
        let vwoContext = VWOUserContext(id: id, customVariables: customVariables)
        return vwoContext
    }
    
    /**
     * Sends SDK initialization event to VWO for analytics and monitoring
     * Tracks when the SDK was initialized for performance monitoring
     * 
     * @param sdkInitTime Timestamp when SDK initialization occurred (Int64)
     * 
     * USAGE:
     * - Call after successful SDK initialization
     * - Use for tracking SDK performance and initialization times
     * - Helps monitor app startup performance
     */
    @objc public func sendSdkInitEvent(sdkInitTime: Int64) {
        // Send SDK initialization event to VWO analytics
        VWOFme.sendSdkInitEvent(sdkInitTime: sdkInitTime)
    }
    
    // MARK: - Feature Flag Operations
    
    /**
     * Retrieves feature flag status and configuration from VWO FME SDK
     * Core method for feature flag evaluation and A/B testing
     * 
     * @param featureKey Unique identifier for the feature flag
     * @param context User context for personalized feature flag evaluation
     * @param completion Completion handler returning GetFlag object with flag status
     * 
     * PREREQUISITES:
     * - SDK must be initialized (isInitialized = true)
     * - Valid user context must be provided
     * 
     * USAGE:
     * - Check if features are enabled for current user
     * - Retrieve A/B testing variables
     * - Implement feature toggles and rollouts
     */
    @objc public func getFlag(featureKey: String, context: VWOUserContext, completion: @escaping (GetFlag) -> Void) {
        // Verify SDK is initialized before proceeding
        if !isInitialized {
            print("Initialize VWO SDK first")
            return
        }
        
        // Request feature flag from VWO FME SDK
        VWOFme.getFlag(featureKey: featureKey, context: context, completion: completion)
    }
    
    @objc public func isFeatureEnabled(feature: GetFlag) -> Bool {
        return feature.isEnabled()
    }
    
    @objc public func getAllVariablesFromFlag(featureFlag: GetFlag) -> [[String: Any]] {
        return featureFlag.getVariables()
    }
    
    @objc public func getVariableValueFromFlag(featureFlag: GetFlag, variableKey: String, defaultValue: Any) -> Any {
        return featureFlag.getVariable(key: variableKey, defaultValue: defaultValue)
    }
    
    @objc public func trackEvent(eventName: String, context: VWOUserContext, eventProperties: [String: Any]? = nil) {
        VWOFme.trackEvent(eventName: eventName, context: context, eventProperties: eventProperties)
    }
    
    @objc public func setAttribute(attributes: [String: Any], context: VWOUserContext) {
        VWOFme.setAttribute(attributes: attributes, context: context)
    }
    

    @objc public func performEventSync() {
        VWOFme.performEventSync()
    }
    
    // MARK: - Log Management
    
    @objc public func getLogs() -> [String] {
        return logsSdk
    }
    
    @objc public func clearLogs() {
        logsSdk.removeAll()
    }
    
    @objc public func getLogsCount() -> Int {
        return logsSdk.count
    }
    
    @objc public func addLogFromObjectiveC(_ message: String) {
        let time = Date().formatted(date: .numeric, time: .standard)
        let logMessage = "\(time) \n\(message)"
        self.logsSdk.append(logMessage)
    }
   
    public func log(logType: String, message: String) {
        let time = Date().formatted(date: .numeric, time: .standard)
        let message = message
        let logMessage = "\(time) \n\(message)"
#if DEBUG
        print(logMessage)
#endif
        self.logsSdk.append(logMessage)
    }
}


