# Capacitor(JavaScript)

This guide provides step-by-step instructions to integrate the FME JavaScript SDK into a Capacitor-based mobile application.

## What is Capacitor?

[Capacitor](https://capacitorjs.com/) is an open-source native runtime developed by the Ionic team that allows you to build cross-platform mobile applications using web technologies like `HTML`, `CSS`, and `JavaScript`. It enables web apps to run natively on iOS, Android, and the web with a single codebase.

## Compatibility with VWO FME JavaScript SDK

The VWO FME JavaScript SDK is designed to work seamlessly within web environments. Since Capacitor wraps web applications in a native container, the VWO FME JavaScript SDK can be integrated directly into the web portion of your Capacitor app. This integration allows you to leverage FME’s features without the need for native SDKs.

## Integration Steps

### 1. Create a Capacitor Project

If you haven’t already set up a Capacitor project, follow these steps:

```bash
npm init @capacitor/app
```

Follow the prompts to set up your app. For detailed instructions, refer to the [Capacitor Getting Started Guide](https://capacitorjs.com/docs/getting-started).

### 2. Add VWO FME JavaScript SDK

Include the FME JavaScript SDK in your index.html file, typically located in the public or www directory of your project. Insert the SDK script tag within the

```html
<head>
  <!-- Other head elements -->
  <script src="https://cdn.jsdelivr.net/npm/vwo-fme-node-sdk@1/dist/client/vwo-fme-javascript-sdk.min.js"></script>
</head>
```

### 3. Initialize FME SDK

After including the SDK, initialize it in your main JavaScript file or within a script tag in your HTML:

```javascript
document.addEventListener('DOMContentLoaded', function () {
  vwoSdk.init({
    accountId: 'VWO_ACCOUNT_ID',
    sdkKey: 'VWO_SDK_KEY'
    // Additional configuration options
  });
});
```

Replace `VWO_ACCOUNT_ID` and `VWO_SDK_KEY` with your actual FME account ID. Refer to the [FME JavaScript documentation](https://developers.vwo.com/v2/docs/fme-javascript) for additional configuration options.

### 4. Build and Sync Your Project

After setting up your project and integrating the FME SDK, build your project and sync it with the native platforms:

```shell
npm run build
npx cap sync
```

This will copy your web assets into the native iOS and Android projects.

## Platform-Specific Setup

### Android

1.	Add the Android platform to your project:

```shell
npx cap add android
```

2.	Open the Android project in `Android Studio`:

```shell
npx cap open android
```

3.	Run your app on an emulator or connected device.

### iOS

1.	Add the iOS platform to your project:

```shell
npx cap add ios
```

2.	Open the iOS project in `Xcode`:

```shell
npx cap open ios
```


3.	Run your app on a simulator or connected device.


<img src="images/screenshot.jpg" alt="variation1 screenshot" width="50%">
<br><br>

# Capacitor Integration with VWO FME JavaScript SDK

> A simple example mobile application showcasing VWO Feature Management and Experimentation (Capacitor) integration, enabling dynamic feature flags and user interaction tracking.

## ✨ Example App Features

- 🎯 User ID-based feature flag evaluation
- 🚦 Feature flag status checking
- 🔄 Real-time settings visualization
- 📊 SDK log monitoring
- 🌐 Interactive web interface
- 📈 Event tracking capabilities
- 🎨 User attributes management


### 📷 Image Credits

The images used in this example app are sourced from [Unsplash](https://unsplash.com), and are free to use under the [Unsplash License](https://unsplash.com/license).
