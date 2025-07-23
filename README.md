# Chat-Bot 💬✨

A sleek, modern AI chatbot application built with Flutter that delivers intelligent responses with a beautiful, user-friendly interface.

-----

## ✨ Key Features

  * **🧠 Intelligent Conversations:** Powered by advanced language models to provide helpful, coherent, and context-aware answers.
  * **💅 Rich Text Formatting:** Full **Markdown** support allows the AI to respond with formatted text, including headers, lists, bold/italic text, and syntax-highlighted code blocks.
  * **⏳ Visual Feedback:** A smooth `LinearProgressIndicator` appears while the AI is "typing," giving users clear feedback that their request is being processed.
  * **🎨 Great Visual Interface:** A clean, chat-bubble-style UI that makes conversations easy to read and visually appealing.
  * **☁️ Firebase Backend:** Securely handles API key management and can be extended to support conversation history.
  * **📱 Cross-Platform:** A single, beautiful codebase for both Android and iOS, thanks to Flutter.

-----

## 🛠️ Technologies Used

  * **Frontend:** [Flutter](https://flutter.dev/)
  * **Backend:** [Firebase](https://firebase.google.com/) (for secure API key handling via Cloud Functions)
  * **AI Model:** [Google Gemini API](https://ai.google.dev/) (or any other large language model)
  * **Markdown Rendering:** `flutter_markdown` package
  * **Language:** [Dart](https://dart.dev/)

-----

### Installation

1.  **Clone the repository:**

sh
    git clone https://github.com/AdityaJandu/FinTrack.git
    cd fintrack

2.  **Install the SDK for flutter and configure project for Firebase.**

-----

## 📂 Project Structure

The project is structured to separate concerns, making it easy to maintain and scale.

```
Of course. Here is the updated `Project Structure` section based on the screenshot you provided.

-----

## 📂 Project Structure

The project is structured to separate concerns, making it easy to maintain and scale.


lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase platform configuration
|
├── models/                   # Data models for the app
│   └── chat_message.dart     # Defines the structure of a chat message
|
├── screens/                  # UI screens for the app
│   └── chat_screen.dart      # The main chat interface screen
|
├── services/                 # Handles external service communication
│   ├── firestore_service.dart# Manages chat history with Firestore
│   └── gemini_service.dart   # Interfaces with the Google Gemini API
|
└── widgets/                  # Reusable UI components for the chat screen
    ├── chat_input_field.dart # The text field and send button
    └── message_bubble.dart     # Widget for displaying a single chat message


```

-----

## 🤝 Contributing

Contributions are what make the open-source community an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

-----
