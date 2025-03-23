import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixsy/features/chatting/domain/message.dart';

abstract class MessageRepo {
  Future<void> sendMessage(Message message, String receiverId);
  Stream<QuerySnapshot> readMessages(String chatRoom);
}
