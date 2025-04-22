import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class FirestoreService {
  final CollectionReference _messagesCollection = FirebaseFirestore.instance
      .collection('chats'); // Or choose a different name

  // Add a message to Firestore
  Future<void> addMessage(ChatMessage message) async {
    try {
      await _messagesCollection.add(message.toFirestore());
    } catch (e) {
      print("Error adding message to Firestore: $e");
      // Handle error appropriately in a real app (e.g., show snackbar)
    }
  }

  // Get a stream of messages ordered by timestamp
  Stream<QuerySnapshot> getMessagesStream() {
    return _messagesCollection
        .orderBy('timestamp', descending: true) // Show newest messages first
        .snapshots();
  }
}
