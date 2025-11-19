import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat/view/chat_page.dart';
import '../../core/constants/app_constants.dart';
import '../cubit/counter_cubit.dart';
import '../cubit/counter_state.dart';
import '../widgets/counter_actions.dart';
import '../widgets/counter_display.dart';

/// Main counter page that displays the counter and allows navigation to chat
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(AppConstants.counterPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => _openChat(context),
            tooltip: AppConstants.chatTooltip,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                return CounterDisplay(value: state.value);
              },
            ),
            const SizedBox(height: 40),
            CounterActions(
              onChatPressed: () => _openChat(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterCubit>().increment(),
        tooltip: AppConstants.incrementTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatPage(),
      ),
    );
  }
}
