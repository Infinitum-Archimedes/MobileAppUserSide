# Student Health Tracker

Welcome to the Student Health Tracker project! This Flutter application is designed to help students manage their health and wellness effectively, by providing analysis based on their location.

## Getting Started

This project serves as a comprehensive starting point for building the Flutter application. Follow the instructions below to set up, demo, and prepare the application for production.

### Prerequisites

Before you begin, ensure you have the following installed on your machine:

- Flutter SDK: [Installation Guide](https://docs.flutter.dev/get-started/install)
- Dart SDK: Included with Flutter
- An IDE (e.g., Android Studio, Visual Studio Code)

### Installation

1. Clone the repository:
   ```bash
   git https://github.com/Team2Infi2024-2025/MobileAppUserSide
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application

To run the application on your local machine, use the following command:
```flutter run```

Ensure to run with keys for all the proper features you want to test:
```
flutter run --dart-define=GOOGLE_MAPS_KEY=SOME_VALUE --dart-define=OTHER_VAR=OTHER_VALUE
``` 


## Navigating the Project

The project is organized into several key directories and files to help you understand its structure and functionality:

- **lib/**: This directory contains the main Dart code for the application. You will find the main entry point in `main.dart`, along with various screens and widgets organized in subdirectories.
  
- **assets/**: This folder holds all the static assets such as images, fonts, and other resources used in the application. Make sure to reference these assets correctly in your code.

- **test/**: This directory is where you can find the unit and widget tests for the application. It is important to write tests to ensure the reliability of your code.

- **pubspec.yaml**: This file manages the dependencies for your Flutter project. You can add or update packages here as needed.

- **README.md**: This file provides an overview of the project, installation instructions, and other relevant information.

To navigate the project effectively, familiarize yourself with these directories and files. You can use your IDE's file explorer to quickly access different parts of the project.

### Context 

The model for this is in a seperate repo and is run in a render server.