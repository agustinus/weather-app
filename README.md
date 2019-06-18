# weather_app

A Flutter project for Weather App.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## Additional Feature
I added a pull to refresh function. It's not being stated on the requirement, but it's good to have.

## Tests
To run flutter driver test, go into the root directory of the project, and use this command:
flutter drive --target=test_driver/app.dart

To run unit test for the bloc, go into the root directory of the project, and use this command:
import 'package:test/test.dart';

## Known Issue
The flutter driver test with mock_web_server needs manually configuration and workaround.
To test using this mock_web_server, we need to set the server manually (for now in this project) to use http://127.0.0.1:8092. The port number is configureable in test_driver/app_test.dart.

## Todo
- Show a proper screen if user doesn't grant the app for location permission.
- Move the geo location function to weather bloc instead.
- Define a proper app name and bundle id/application id.
- Broader app test coverage e.g error handling for missing key/value from the api, etc.