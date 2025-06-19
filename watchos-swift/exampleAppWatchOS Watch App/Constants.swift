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

struct Constants {
    
    enum Keys {
        static let flagKey = "VWO_FLAG_KEY"
        static let variable1Key = "VWO_FLAG_VARIABLE_1_KEY"
        static let variable2Key = "VWO_FLAG_VARIABLE_2_KEY"
        static let variable3Key = "VWO_FLAG_VARIABLE_3_KEY"
        static let eventName = "VWO_EVENT_NAME"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist not found")
        }
        return dict
    }()
    
    private static func getValue(forKey key: String) -> String {
        guard let value = infoDictionary[key] as? String else {
            fatalError("Error: \(key) not found. Please verify that your .xcconfig file is included in the project and contains the necessary key-value pairs.")
        }
        return value
    }
    
    // Feature Flag Names
    struct FeatureFlags {
        static let fmeExample = getValue(forKey: Keys.flagKey)
        static let variableKey1 = getValue(forKey: Keys.variable1Key)
        static let variableKey2 = getValue(forKey: Keys.variable2Key)
        static let variableKey3 = getValue(forKey: Keys.variable3Key)

    }
    
    // Event Names
    struct Events {
        static let userInteracted = getValue(forKey: Keys.eventName)
    }
}


enum SdkEnvironment {
    
    enum Keys {
        static let sdkKey = "VWO_SDK_KEY"
        static let accountID = "VWO_ACCOUNT_ID"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist not found")
        }
        return dict
    }()
    
    static let sdkKey: String = {
        guard let keyString = SdkEnvironment.infoDictionary[Keys.sdkKey] as? String else {
            fatalError("Error: SDK_KEY not found. Please verify that your .xcconfig file is included in the project and contains the necessary key-value pairs.")
        }
        return keyString
    }()
    
    static let accountID: Int = {
        guard let accountIdString = SdkEnvironment.infoDictionary[Keys.accountID] as? String else {
            fatalError("Error: ACCOUNT_ID not found. Please verify that your .xcconfig file is included in the project and contains the necessary key-value pairs.")
        }
        
        guard let accountId = Int(accountIdString) else {
            fatalError("Error: ACCOUNT_ID could not be parsed. Ensure it is set as a valid integer in your .xcconfig file.")
        }
        
        return accountId
    }()
}
