# ⌚ watchOS Podcast Player with VWO FME Integration

> A sleek watchOS application showcasing VWO Feature Management and Experimentation (FME) integration, enabling dynamic feature flags to customize UI elements and user interactions on Apple Watch.


## ✨ Example App Features

- 🎛️ Dynamic feature flags controlling:
    - Playback speed control visibility (playbackSpeedControl)
    - Settings button enablement (settingsEnabled)
    - Dark mode toggle (darkModeEnabled)
- 📊 User interaction tracking with VWO FME SDK


## 🚀 Prerequisites

Before you begin, ensure you have:

- Xcode
- FME product enabled for your VWO account

## 💻 Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/wingify/vwo-fme-examples.git
    cd vwo-fme-examples/watchos-swift
    ```

2. Open file `exampleAppWatchOS.xcodeproj` in Xcode

3. Add `Config.xcconfig` file and adding below environment variables in project at root level.

    ```bash
    VWO_ACCOUNT_ID = vwo_account_id
    VWO_SDK_KEY = vwo_sdk_key
    VWO_FLAG_KEY = vwo_flag_key
    VWO_FLAG_VARIABLE_1_KEY = vwo_flag_variable_key_1
    VWO_FLAG_VARIABLE_2_KEY = vwo_flag_variable_key_2
    VWO_FLAG_VARIABLE_3_KEY = vwo_flag_variable_key_3
    VWO_EVENT_NAME = vwo_event_name
    ```

## 🔧 Usage

### Feature Flag Setup in VWO FME

1. **Create a Feature Flag in VWO FME:**
   - **Name:** `watchOS Podcast Player Customization`
   - **Variables:**
     - `playbackSpeedControl` with default value `false`
     - `settingsEnabled` with default value `true`
     - `darkModeEnabled` with default value `false`

     - <img src="./screenshots/all-variables.png" width="600" alt="VWO FME Variables Configuration">


2. **Create Variations:**
   - **Variation 1:**
     - `playbackSpeedControl`: `true`
     - `settingsEnabled`: `true`
     - `darkModeEnabled`: `false`
   - **Variation 2:**
     - `playbackSpeedControl`: `true`
     - `settingsEnabled`: `true`
     - `darkModeEnabled`: `true`

     - <img src="./screenshots/all-variations.png" width="600" alt="VWO FME Variations Configuration">

3. **Create a Rollout and Testing Rule:**
   - Set up the feature flag with the above variations.

4. **Configure Your tvOS App:**
   - Add all the config details in `Config.xcconfig` file.

    ```bash
    VWO_ACCOUNT_ID = vwo_account_id
    VWO_SDK_KEY = vwo_sdk_key
    VWO_FLAG_KEY = vwo_flag_key
    VWO_FLAG_VARIABLE_1_KEY = vwo_flag_variable_key_1
    VWO_FLAG_VARIABLE_2_KEY = vwo_flag_variable_key_2
    VWO_FLAG_VARIABLE_3_KEY = vwo_flag_variable_key_3
    VWO_EVENT_NAME = vwo_event_name
    ```

5. **Run the App in Xcode:**
   - Use the Simulator to test the app.

6. **Interact with the App:**

   <img src="./screenshots/default.png" style="width: 400px; height: auto;" alt="VWO FME Variables Configuration"> <img src="./screenshots/variation-1.png" style="width: 400px; height: auto;" alt="VWO FME Variables Configuration"> <img src="./screenshots/variation-2.png" style="width: 400px; height: auto;" alt="VWO FME Variables Configuration">
