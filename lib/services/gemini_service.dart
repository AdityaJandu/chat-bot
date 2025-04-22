import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GenerativeModel? _model;

  GeminiService() {
    _initialize();
  }

  void _initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      print("Error: GEMINI_API_KEY not found in .env file.");
      // Handle this error more gracefully in a production app
      return;
    }
    // For text-only input, use the gemini-pro model
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
  }

  Future<String?> getResponse(String userMessage) async {
    if (_model == null) {
      print("Error: Gemini model not initialized.");
      return "Sorry, the AI service is not available right now.";
    }

    try {
      // --- Basic Text Generation ---
      // final content = [Content.text(userMessage)];
      // final response = await _model!.generateContent(content);
      // return response.text;

      // --- Chat (Conversation History) ---
      // For a better chatbot experience, use startChat
      // You might need to manage chat history more robustly in a real app
      final chat = _model!
          .startChat(); // Start a new chat session each time for simplicity here
      final content = Content.text(userMessage);
      final response = await chat.sendMessage(content);

      print("Gemini Response Raw: ${response.text}"); // Debugging
      return response.text;
    } catch (e) {
      print("Error calling Gemini API: $e");
      // Provide a user-friendly error message
      return "Sorry, I couldn't process that request. Error: ${e.toString()}";
    }
  }
}
