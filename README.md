# Sign Language Chat Application

![App Architecture](app_architecture.png)

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
