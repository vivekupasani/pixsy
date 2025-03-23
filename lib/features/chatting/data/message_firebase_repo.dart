import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixsy/features/chatting/domain/message.dart';
import 'package:pixsy/features/chatting/domain/message_repo.dart';

class MessageFirebaseRepo implements MessageRepo {
  //firebase instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //method to read messages
  @override
  Stream<QuerySnapshot> readMessages(String chatRoom) {
    return firestore
        .collection('chats')
        .doc(chatRoom)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  //method to send message
  @override
  Future<void> sendMessage(Message message, String receiverId) async {
    try {
      // Generate a consistent chat room ID by sorting the IDs
      final participants = [message.senderId, receiverId]..sort();
      final chatRoom = participants.join("_");

      await firestore
          .collection('chats')
          .doc(chatRoom)
          .collection('messages')
          .add(message.toJson());
    } catch (e) {
      throw Exception("Sending message failed. $e");
    }
  }
}
