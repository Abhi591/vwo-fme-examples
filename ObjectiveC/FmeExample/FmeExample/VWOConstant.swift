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

@objc public class VWOConstants: NSObject {
    @objc public static let VWO_SDK_VERSION = "1.0.0"
    @objc public static let SDK_KEY = "SDK_Key"
    @objc public static let ACCOUNT_ID = 1234
    @objc public static let flagKey = "VWO_FLAG_KEY"
    @objc public static let variable1Key = "VWO_FLAG_VARIABLE_1_KEY"
    @objc public static let variable2Key = "VWO_FLAG_VARIABLE_2_KEY"
    @objc public static let eventName = "VWO_EVENT_NAME"
    
    @objc public static let searchQuery = "I forgot my password"
    @objc public static let DefaultBotResponse = """
    To reset your password:
      1. Open the app and go to the login screen.
      2. Tap ‘Forgot Password?’ below the password field.
      3. Enter your registered email address and submit.
      4. Check your inbox for a password reset email (it may take a few minutes).
      5. Click the link in the email and follow the instructions to create a new password.
      6. Return to the app and log in with your new password.
    """
}
