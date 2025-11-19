import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../counter/cubit/counter_cubit.dart';
import '../../counter/cubit/counter_state.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../repositories/chat_repository_impl.dart';
import '../services/counter_tool_executor.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/tool_execution_indicator.dart';

/// Main chat page that displays the AI chat interface
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counterCubit = context.read<CounterCubit>();

    // Create repository and tool executor
    final repository = ChatRepositoryImpl(
      serverUrl: AppConstants.serverUrl,
    );

    final toolExecutor = CounterToolExecutor(
      counterCubit: counterCubit,
    );

    final user = ChatUser(id: '1', firstName: 'User');
    final ai = ChatUser(
      id: '2',
      firstName: 'AI',
      lastName: 'Assistant',
    );

    return BlocProvider(
      create: (context) => ChatCubit(
        repository: repository,
        toolExecutor: toolExecutor,
        counterCubit: counterCubit,
        user: user,
        ai: ai,
      ),
      child: const _ChatPageContent(),
    );
  }
}

class _ChatPageContent extends StatelessWidget {
  const _ChatPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.chatPageTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Show current counter value
          BlocBuilder<CounterCubit, CounterState>(
            builder: (context, state) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Counter: ${state.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return Column(
            children: [
              // Show tool execution indicator
              if (state.currentToolExecution != null)
                ToolExecutionIndicator(
                  executionMessage: state.currentToolExecution!,
                ),

              // Chat interface
              Expanded(
                child: ChatMessageList(
                  messages: state.messages,
                  currentUser: ChatUser(id: '1', firstName: 'User'),
                  aiUser: ChatUser(
                    id: '2',
                    firstName: 'AI',
                    lastName: 'Assistant',
                  ),
                  onSend: (message) {
                    context.read<ChatCubit>().sendMessage(message.text);
                  },
                  isProcessing: state.isProcessing,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
