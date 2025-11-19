import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Widget that displays action buttons for the counter
class CounterActions extends StatelessWidget {
  final VoidCallback onChatPressed;

  const CounterActions({
    super.key,
    required this.onChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onChatPressed,
      icon: const Icon(Icons.chat_bubble),
      label: const Text(AppConstants.chatActionButton),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    );
  }
}
