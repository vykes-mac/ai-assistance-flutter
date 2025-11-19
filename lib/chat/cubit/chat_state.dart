import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:equatable/equatable.dart';

/// State for the chat feature
class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isProcessing;
  final String? currentToolExecution;
  final String? error;

  const ChatState({
    required this.messages,
    required this.isProcessing,
    this.currentToolExecution,
    this.error,
  });

  /// Initial state with welcome message
  ChatState.initial({
    required ChatUser aiUser,
  })  : messages = [
          ChatMessage(
            user: aiUser,
            createdAt: DateTime.now(),
            text:
                'Hello! I can help you control the counter. Try asking me to increment, decrement, reset, or set it to a specific value!',
          ),
        ],
        isProcessing = false,
        currentToolExecution = null,
        error = null;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isProcessing,
    String? currentToolExecution,
    String? error,
    bool clearToolExecution = false,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
      currentToolExecution:
          clearToolExecution ? null : (currentToolExecution ?? this.currentToolExecution),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props =>
      [messages, isProcessing, currentToolExecution, error];
}
