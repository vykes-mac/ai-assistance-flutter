import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../counter/cubit/counter_cubit.dart';
import '../../counter/cubit/counter_state.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../repositories/chat_repository_impl.dart';
import '../services/composite_tool_executor.dart';
import '../services/counter_tool_executor.dart';
import '../services/navigation_tool_executor.dart';
import 'chat_message_list.dart';
import 'tool_execution_indicator.dart';

/// Shows the chat interface as a modal bottom sheet
Future<void> showChatModal(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ChatModal(onClose: () => Navigator.pop(context)),
  );
}

/// Chat modal bottom sheet widget
class ChatModal extends StatelessWidget {
  final VoidCallback onClose;

  const ChatModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final counterCubit = context.read<CounterCubit>();

    // Create repository and tool executors
    final repository = ChatRepositoryImpl(serverUrl: AppConstants.serverUrl);

    final counterExecutor = CounterToolExecutor(counterCubit: counterCubit);

    final navigationExecutor = NavigationToolExecutor();

    final compositeExecutor = CompositeToolExecutor(
      executors: [counterExecutor, navigationExecutor],
    );

    final user = ChatUser(id: '1', firstName: 'User');
    final ai = ChatUser(id: '2', firstName: 'AI', lastName: 'Assistant');

    return BlocProvider(
      create: (context) => ChatCubit(
        repository: repository,
        toolExecutor: compositeExecutor,
        counterCubit: counterCubit,
        user: user,
        ai: ai,
      ),
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              AppConstants.chatPageTitle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                // Show current counter value
                                BlocBuilder<CounterCubit, CounterState>(
                                  builder: (context, state) {
                                    return Text(
                                      'Counter: ${state.value}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: onClose,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Chat content
                      Expanded(
                        child: BlocBuilder<ChatCubit, ChatState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                // Show tool execution indicator
                                if (state.currentToolExecution != null)
                                  ToolExecutionIndicator(
                                    executionMessage:
                                        state.currentToolExecution!,
                                  ),

                                // Chat interface
                                Expanded(
                                  child: ChatMessageList(
                                    messages: state.messages,
                                    currentUser: user,
                                    aiUser: ai,
                                    onSend: (message) {
                                      context.read<ChatCubit>().sendMessage(
                                        message.text,
                                      );
                                    },
                                    isProcessing: state.isProcessing,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
