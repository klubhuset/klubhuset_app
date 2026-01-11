# klubhuset

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Test user

test@klubhuset.dk
123456

# App Store TestFlight Guide

## Part 1:

1. Open the Runner.xcworkspace in XCode
2. Go to Product -> Archive
3. Click Distribute App -> Choose App Store Connect -> Upload

## Part 2:

1. Go to App Store Connect
2. Choose the app -> tab TestFlight

# Google Play Console Guide

## Before uploading

Two main files needs to exists before being able to upload the App.

1. A generated keystore has to be used to sign and upload the App.
   - For now, a test keystore has been created
     - Current Keystore location: /Users/holstchayder/Development/GitHub/klubhuset_app/android/app/my-release-key.jks
   - To generate a new one, make Java is installed and run: "keytool -genkeypair -v \ -keystore ~/my-release-key.jks \ -keyalg RSA -keysize 2048 -validity 10000 \ -alias my-key-alias"
2. A key.properties file (placed in /Users/holstchayder/Development/GitHub/klubhuset_app/android/key.properties) with the following values:
   - keyAlias=my-key-store-password
   - keyAlias=my-key-password
   - keyAlias=my-key-alias
   - storeFile=my-release-key.jks

## Uploading the app

1. Run "flutter build appbundle --build-number=$(date +%s)"
2. Go to "build/app/outputs/bundle/release/" and find the file "app-release.aab"
3. Upload the file to Google Play Console
