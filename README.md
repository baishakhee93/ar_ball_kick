# ar_ball_kick
# Flutter AR Ball Interaction App

## Overview

This Flutter application demonstrates an augmented reality (AR) interaction where a virtual ball appears on the screen, moves towards the user's leg, and responds to leg movements (like a kick). The app uses the device's camera and integrates AR frameworks to achieve this functionality.

## Features

- **Camera Integration**: Captures live video feed using the device's camera.
- **AR Framework**: Utilizes ARCore (for Android) and ARKit (for iOS) to overlay digital content onto the real-world camera feed.
- **Leg Movement Detection**: Detects leg movement using computer vision techniques.
- **Ball Interaction**: Renders a virtual ball that moves towards the user's legs and detects kicks.
- **New Ball Generation**: Generates a new ball after the previous one is kicked.

## Setup

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Android Studio or Xcode (for iOS development)
- A device with a camera

### Dependencies

Add the following dependencies to your `pubspec.yaml` file:

``yaml
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.9.4+5
  arcore_flutter_plugin: ^0.0.10
  arkit_plugin: ^0.6.0
  permission_handler: ^10.0.0
  provider: ^6.0.3
  
# Project Structure
main.dart: Entry point of the application.
home_screen.dart: Home screen with a button to start the AR experience.
camera_screen.dart: Screen that initializes and shows the camera feed.
ar_screen.dart: Main AR screen that chooses between Android and iOS AR views.
android_ar_view.dart: Android-specific AR view using ARCore.
ios_ar_view.dart: iOS-specific AR view using ARKit.
ball_screen.dart: Screen that handles the ball's movement and interaction.

# Usage
Home Screen: Click the "Start" button to navigate to the camera screen.
Camera Screen: The app will request camera permissions. Allow the permission to see the live camera feed. Click the forward arrow button to move to the AR screen.
AR Screen: Depending on the platform (Android or iOS), the respective AR view will be displayed. Interact with the AR content by tapping on the screen to add the ball.
Ball Interaction: The ball will move towards your leg, and leg movement detection will take place. Reset detection using the provided button if needed.






