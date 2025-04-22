import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageSender { user, model }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final Timestamp timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  // Factory constructor to create a ChatMessage from a Firestore document
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      text: data['text'] ?? '',
      sender: (data['sender'] ?? 'model') == 'user'
          ? MessageSender.user
          : MessageSender.model,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Method to convert ChatMessage to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'sender': sender == MessageSender.user ? 'user' : 'model',
      'timestamp': timestamp,
    };
  }
}
