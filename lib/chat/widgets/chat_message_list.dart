import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

/// Widget that displays the list of chat messages
class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ChatUser currentUser;
  final ChatUser aiUser;
  final Function(ChatMessage) onSend;
  final bool isProcessing;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.currentUser,
    required this.aiUser,
    required this.onSend,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return DashChat(
      currentUser: currentUser,
      onSend: onSend,
      messages: messages,
      messageOptions: MessageOptions(
        showTime: true,
        avatarBuilder: (user, onAvatarTap, onAvatarLongPress) {
          return CircleAvatar(
            backgroundColor:
                user.id == currentUser.id ? Colors.blue : Colors.green,
            child: Text(
              user.id == currentUser.id ? 'U' : 'AI',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      inputOptions: InputOptions(
        inputDecoration: InputDecoration(
          hintText: isProcessing
              ? 'Processing...'
              : 'Ask me to control the counter...',
          border: const OutlineInputBorder(),
        ),
        sendButtonBuilder: (onSend) {
          return IconButton(
            onPressed: isProcessing ? null : onSend,
            icon: Icon(
              Icons.send,
              color: isProcessing ? Colors.grey : Colors.blue,
            ),
          );
        },
      ),
    );
  }
}
