import 'package:chatbot/models/chat_message.dart';
import 'package:chatbot/services/firestore_service.dart';
import 'package:chatbot/services/gemini_service.dart';
import 'package:chatbot/widgets/chat_input_field.dart';
import 'package:chatbot/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final GeminiService _geminiService = GeminiService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // Function to send message (user) and get response (model)
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Add user message to Firestore and UI
    final userMessage = ChatMessage(
      text: text.trim(),
      sender: MessageSender.user,
      timestamp: Timestamp.now(),
    );
    await _firestoreService.addMessage(userMessage);

    // Scroll to bottom after sending
    _scrollToBottom();

    // 2. Show loading indicator
    setState(() {
      _isLoading = true;
    });

    // 3. Get response from Gemini
    final responseText = await _geminiService.getResponse(text.trim());

    // 4. Add model response to Firestore and UI
    if (responseText != null && responseText.isNotEmpty) {
      final modelMessage = ChatMessage(
        text: responseText,
        sender: MessageSender.model,
        timestamp: Timestamp.now(),
      );
      await _firestoreService.addMessage(modelMessage);
    } else {
      // Handle cases where Gemini didn't respond or gave an error
      final modelMessage = ChatMessage(
        text: "Sorry, I couldn't get a response. Please try again.",
        sender: MessageSender.model,
        timestamp: Timestamp.now(),
      );
      await _firestoreService.addMessage(modelMessage);
    }

    // 5. Hide loading indicator
    setState(() {
      _isLoading = false;
    });

    // Scroll to bottom after receiving response
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Needs a slight delay for the UI to update after adding a message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController
              .position.minScrollExtent, // To scroll to bottom when reversed
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Start chatting!'));
                }

                // Map Firestore docs to ChatMessage objects
                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Makes list start from bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(
                      message: message.text,
                      isUser: message.sender == MessageSender.user,
                      timestamp: message.timestamp, // Pass timestamp
                    );
                  },
                );
              },
            ),
          ),
          // Optional: Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: LinearProgressIndicator(
                minHeight: 2, // Make it subtle
              ),
            ),
          // Input field
          ChatInputField(
            onSendMessage: _sendMessage,
            isLoading: _isLoading, // Disable input while loading
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
