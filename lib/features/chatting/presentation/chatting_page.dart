import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/features/chatting/data/message_firebase_repo.dart';
import 'package:pixsy/features/chatting/domain/message.dart';
import 'package:pixsy/features/profile/domain/profile_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixsy/responsive/magic_box.dart';

class ChattingPage extends StatefulWidget {
  final ProfileUser? eachUser;
  final bool isOwn;
  const ChattingPage({super.key, required this.eachUser, required this.isOwn});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() {
    final authCubit = context.read<AuthenticationCubit>();
    final currentUser = authCubit.currentuser;

    if (currentUser != null &&
        widget.eachUser != null &&
        _messageController.text.trim().isNotEmpty) {
      Message message = Message(
        message: _messageController.text.trim(),
        senderId: currentUser.uid,
        timestamp: Timestamp.now(),
      );

      MessageFirebaseRepo().sendMessage(message, widget.eachUser!.uid);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthenticationCubit>();
    final currentUser = authCubit.currentuser;

    if (currentUser == null || widget.eachUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Chat")),
        body: const Center(child: Text("Unable to load chat.")),
      );
    }

    final participants = [currentUser.uid, widget.eachUser!.uid]..sort();
    final chatRoom = participants.join("_");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOwn
            ? "${widget.eachUser?.name}(Me)"
            : widget.eachUser?.name ?? "Chat"),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: MessageFirebaseRepo().readMessages(chatRoom),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }

                  final messages = snapshot.data!.docs.map((doc) {
                    return Message.fromJson(doc.data() as Map<String, dynamic>);
                  }).toList();

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser = message.senderId == currentUser.uid;

                      return Center(
                        child: MagicBox(
                          maxWidth: 720,
                          child: Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.blue
                                    : Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                message.message,
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Center(
              child: MagicBox(
                maxWidth: 720,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Colors.blue,
                              ),
                              onPressed: sendMessage,
                            ),
                          ],
                        ),
                      ),
                      hintText: 'Type a message!',
                      hintStyle:
                          TextStyle(color: Theme.of(context).colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
