import 'package:app_use_server_client/app_use_server_client.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../counter/cubit/counter_cubit.dart';
import '../repositories/chat_repository.dart';
import '../services/tool_executor.dart';
import 'chat_state.dart';

/// Cubit that manages chat state and interactions
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  final ToolExecutor _toolExecutor;
  final CounterCubit _counterCubit;
  final ChatUser _user;
  final ChatUser _ai;

  ChatCubit({
    required ChatRepository repository,
    required ToolExecutor toolExecutor,
    required CounterCubit counterCubit,
    required ChatUser user,
    required ChatUser ai,
  })  : _repository = repository,
        _toolExecutor = toolExecutor,
        _counterCubit = counterCubit,
        _user = user,
        _ai = ai,
        super(ChatState.initial(aiUser: ai));

  /// Send a user message
  Future<void> sendMessage(String text) async {
    if (state.isProcessing) return;

    final userMessage = ChatMessage(
      user: _user,
      createdAt: DateTime.now(),
      text: text,
    );

    // Add user message to list
    emit(state.copyWith(
      messages: [userMessage, ...state.messages],
      isProcessing: true,
      clearError: true,
    ));

    try {
      // Convert history
      final history = _convertHistoryForServer();

      // Create request
      final request = ChatRequestData(
        message: text,
        currentCounterValue: _counterCubit.state.value,
        history: history.isNotEmpty ? history : null,
        toolResults: null,
      );

      // Send to server
      final response = await _repository.sendMessage(request);

      // Process response
      await _processResponse(response);
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isProcessing: false,
        clearToolExecution: true,
      ));
      _addErrorMessage('Error: ${e.toString()}');
    }
  }

  /// Convert messages to history format for server
  List<ChatHistoryItem> _convertHistoryForServer() {
    // Get last 10 messages (excluding the one we just sent)
    final recentMessages = state.messages.skip(1).take(10).toList().reversed;

    return recentMessages.map((msg) {
      return ChatHistoryItem(
        role: msg.user.id == _user.id ? 'user' : 'assistant',
        text: msg.text,
      );
    }).toList();
  }

  /// Process the response from the server
  Future<void> _processResponse(ChatResponseData response) async {
    String? accumulatedText;
    List<ToolResultItem> toolResults = [];

    // Process each response item
    for (final item in response.responses) {
      if (item.type == 'text') {
        // Accumulate text responses
        accumulatedText = (accumulatedText ?? '') + (item.content ?? '');
      } else if (item.type == 'tool_call') {
        // Execute tool call
        if (item.toolName != null) {
          emit(state.copyWith(
            currentToolExecution: 'Executing: ${item.toolName}',
          ));

          // Small delay to show the execution message
          await Future.delayed(const Duration(milliseconds: 300));

          final result = _toolExecutor.executeTool(
            item.toolName!,
            item.args,
          );

          // Store tool result for potential follow-up
          String responseContent = result.message;
          if (result.history != null && result.history!.isNotEmpty) {
            responseContent += '\nHistory:\n- ${result.history!.join('\n- ')}';
          } else if (result.history != null) {
            responseContent += '\nHistory is empty.';
          }

          toolResults.add(
            ToolResultItem(name: item.toolName!, response: responseContent),
          );
        }
      }
    }

    // Add the accumulated response with typewriter effect
    if (accumulatedText != null && accumulatedText.isNotEmpty) {
      await _showMessageWithTypewriter(accumulatedText);
    }

    // If we executed tools, send results back to server to complete the turn
    if (toolResults.isNotEmpty) {
      try {
        final request = ChatRequestData(
          message: '', // Empty message for tool response
          currentCounterValue: _counterCubit.state.value,
          history: _convertHistoryForServer(),
          toolResults: toolResults,
        );

        final followUpResponse = await _repository.sendMessage(request);
        await _processResponse(followUpResponse);
      } catch (e) {
        emit(state.copyWith(
          error: e.toString(),
          isProcessing: false,
          clearToolExecution: true,
        ));
      }
    } else {
      // No more tools to execute, finish processing
      emit(state.copyWith(
        isProcessing: false,
        clearToolExecution: true,
      ));
    }
  }

  /// Display message with typewriter effect
  Future<void> _showMessageWithTypewriter(String fullText) async {
    // Create an empty message
    final message = ChatMessage(
      user: _ai,
      createdAt: DateTime.now(),
      text: '',
    );

    emit(state.copyWith(
      messages: [message, ...state.messages],
    ));

    // Typewriter effect: add characters gradually
    const charsPerBatch = 3;
    const delayPerBatch = Duration(milliseconds: 30);

    for (int i = 0; i < fullText.length; i += charsPerBatch) {
      final end = (i + charsPerBatch > fullText.length)
          ? fullText.length
          : i + charsPerBatch;

      final updatedMessage = ChatMessage(
        user: _ai,
        createdAt: message.createdAt,
        text: fullText.substring(0, end),
      );

      final updatedMessages = List<ChatMessage>.from(state.messages);
      updatedMessages[0] = updatedMessage;

      emit(state.copyWith(messages: updatedMessages));

      await Future.delayed(delayPerBatch);
    }
  }

  /// Add an error message to the chat
  void _addErrorMessage(String error) {
    final errorMessage = ChatMessage(
      user: _ai,
      createdAt: DateTime.now(),
      text: '⚠️ $error',
    );

    emit(state.copyWith(
      messages: [errorMessage, ...state.messages],
      isProcessing: false,
      clearToolExecution: true,
    ));
  }

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }
}
