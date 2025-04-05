# Flutter Ringtone Manager

A Flutter application that demonstrates native module integration by accessing the device's default ringtone on both Android and iOS platforms, along with implementing security features.

## Features

- **Native Module Integration**: Accessing device ringtone using platform-specific code
  - Android: Using RingtoneManager
  - iOS: Using AVAudioPlayer with bundled sound

- **Security Features**:
  - Secure storage for ringtone data
  - Biometric authentication (fingerprint)

- **State Management**:
  - GetX for efficient state management

- **User Interface**:
  - Clean, responsive UI
  - Support for both light and dark modes

- **Permission Handling**:
  - Runtime permission requests for audio/storage access
  - Proper error handling for denied permissions

## Getting Started

### Prerequisites

- Flutter SDK 3.27.2
- Android Studio / Xcode
- Physical device or emulator with fingerprint capability for testing biometric authentication

### Installation

1. Clone the repository:

```bash
git clone https://github.com/amAkshay18/ringtone_manager.git
cd ringtone-manager
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## App Flow

1. **Permission Request**: On first launch, the app requests necessary permissions to access ringtones
2. **Biometric Authentication**: Fingerprint authentication is required before accessing ringtone functionality
3. **Ringtone Management**: Once authenticated, users can:
   - Fetch the default ringtone information
   - Play the default ringtone
   - View ringtone details securely stored between sessions

## Technical Implementation

### Native Module Integration

Platform-specific code is implemented using Method Channels:

- **Android**: Kotlin implementation using RingtoneManager API
- **iOS**: Swift implementation using AVAudioPlayer with a bundled sound file

### Security Implementation

- **Secure Storage**: Uses `flutter_secure_storage` to encrypt and store ringtone data
- **Biometric Authentication**: Uses `local_auth` to implement fingerprint authentication

### Architecture

The app follows a clean architecture pattern:

- **Services**: Handle platform interactions and data storage
- **Controllers**: Manage application state and business logic
- **Views**: Present UI and respond to user interactions

## Dependencies

- `get`: ^4.6.6 - State management
- `flutter_secure_storage`: ^8.0.0 - Secure data storage
- `permission_handler`: ^10.4.3 - Permission management
- `local_auth`: ^2.1.6 - Biometric authentication

## Platform-Specific Configuration

### Android

Required permissions in AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

### iOS

Required entries in Info.plist:
```xml
<key>NSFaceIDUsageDescription</key>
<string>This app requires biometric authentication to access ringtone functionality</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app requires microphone access to play ringtones</string>
```

## Known Limitations

- iOS doesn't provide public API access to system ringtones, so the app uses a bundled sound file
- Biometric authentication requires devices with hardware support

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for their excellent documentation
- GetX library for efficient state management
