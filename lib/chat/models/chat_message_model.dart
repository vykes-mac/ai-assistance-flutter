import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:equatable/equatable.dart';

/// Model for chat messages with additional metadata
class ChatMessageModel extends Equatable {
  final ChatMessage message;
  final bool isTyping;

  const ChatMessageModel({
    required this.message,
    this.isTyping = false,
  });

  ChatMessageModel copyWith({
    ChatMessage? message,
    bool? isTyping,
  }) {
    return ChatMessageModel(
      message: message ?? this.message,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [message, isTyping];
}
