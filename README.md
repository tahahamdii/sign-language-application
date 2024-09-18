# Sign Language Chat Application


## Overview

This Flutter application is designed for real-time sign language communication. The app integrates TensorFlow for detecting sign language gestures using the device’s camera during chat sessions and reformulates these detected signs into phrases using OpenAI API. The chat is powered by WebSockets for real-time interaction, and the authentication system is handled via a secure Spring Boot backend.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [API Endpoints](#api-endpoints)
- [TensorFlow Sign Detection](#tensorflow-sign-detection)
- [OpenAI API Integration](#openai-api-integration)
- [WebSocket Communication](#websocket-communication)
- [Contributing](#contributing)
- [Contact](#contact)
- [License](#license)

## Features

- **JWT Authentication**: Secure user authentication through a Spring Boot backend.
- **Real-time WebSocket Chat**: Instant messaging between users.
- **TensorFlow-based Sign Language Detection**: Uses the device camera to detect and interpret sign language gestures.
- **OpenAI API Integration**: Converts detected sign language gestures into coherent phrases.
- **Image Upload**: Upload profile pictures and other media using the backend (powered by Cloudinary).

## Prerequisites

- **Flutter SDK** (2.0+)
- **Dart SDK**
- **TensorFlow Lite** for sign language detection
- **OpenAI API Key** for sign-to-text translation
- **Backend**: [Sign Language Spring Boot Backend](https://github.com/yourusername/sign-language-backend)
- **Android Studio/Visual Studio Code** (with Flutter plugin)
- **Mobile Device or Emulator**

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/sign-language-chat-app.git
   cd sign-language-chat-app
1.  **Install Flutter Dependencies**



    `flutter pub get`

Configuration
-------------

1.  **Backend Configuration**

    Make sure you have the backend server running for authentication and chat functionalities. Follow the backend instructions [here](https://github.com/yourusername/sign-language-backend).

2.  **OpenAI API Key**

    Obtain your OpenAI API key from [OpenAI](https://beta.openai.com/signup/) and add it to your Flutter project:

    Open `lib/config.dart` and add your API key:



    `const String openAiApiKey = 'your_openai_api_key';`

3.  **TensorFlow Model**

    Download the pre-trained TensorFlow Lite model for sign language detection and place it in the `assets/tflite/` directory. Update your `pubspec.yaml` file to include the model:


    `assets:
      - assets/tflite/sign_language_model.tflite`

4.  **Application Properties**

    Ensure the backend is running and accessible through your local or deployed environment. Update `lib/config.dart` with the backend API URL:



    `const String backendUrl = 'http://localhost:8080';`

Running the Application
-----------------------

1.  **Run on Android/iOS Emulator or Device**

    Connect a device or open an emulator and run:



    `flutter run`

2.  **Logging in**

    Create an account using the registration flow or use existing credentials to log in.

API Endpoints
-------------

### Authentication (Backend)

-   **Register User**



    `POST /auth/register`

-   **Login User**



    `POST /auth/login`

### Chat and WebSocket

The chat feature utilizes WebSocket for real-time communication. The WebSocket endpoint is:



`/ws/chat`

This endpoint allows users to send and receive messages, including sign language-based inputs detected by TensorFlow.

TensorFlow Sign Detection
-------------------------

This app utilizes **TensorFlow Lite** to detect sign language gestures in real-time. The model is integrated with the device's camera to capture the user's signs and interpret them.

-   **Camera Feed**: Opens the device's camera and continuously captures hand gestures.
-   **Model**: The TensorFlow Lite model detects specific sign language gestures from the camera feed.
-   **Output**: The recognized gestures are fed into the OpenAI API for phrase reconstruction.

OpenAI API Integration
----------------------

After detecting individual sign language gestures using TensorFlow, the app sends the detected gestures to OpenAI's API to form a meaningful phrase. The API key is required for this step.

### OpenAI API Example

Once a sign is detected, a request is made to the OpenAI API:


`Future<String> translateSignsToPhrase(List<String> detectedSigns) async {
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/completions'),
    headers: {
      'Authorization': 'Bearer $openAiApiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'text-davinci-003',
      'prompt': 'Translate the following signs to a phrase: ${detectedSigns.join(", ")}',
      'max_tokens': 50,
    }),
  );

  final data = jsonDecode(response.body);
  return data['choices'][0]['text'].trim();
}`

WebSocket Communication
-----------------------

WebSocket is used to enable real-time chat between users. Detected signs are translated into phrases via OpenAI and sent over WebSocket.

-   **Endpoint**: `/ws/chat`
-   **Description**: Handles real-time communication between users, including reformulated sign language phrases.

Docker Deployment (Backend)
---------------------------

The backend of this application is Dockerized for seamless deployment. You can refer to the backend's [README](https://github.com/yourusername/sign-language-backend) for detailed Docker instructions.

Contributing
------------

Contributions are welcome! Please open an issue or submit a pull request for any improvements.

Contact
-------

Developed by **Taha Hamdi**

-   **Email**: hamdi.taha@esprit.tn

