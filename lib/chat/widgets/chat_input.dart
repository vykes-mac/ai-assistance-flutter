import 'package:flutter/material.dart';

/// Widget for chat input (placeholder for future customization)
class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEnabled,
              decoration: InputDecoration(
                hintText: isEnabled
                    ? 'Ask me to control the counter...'
                    : 'Processing...',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: isEnabled ? (_) => onSend() : null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.send,
              color: isEnabled ? Colors.blue : Colors.grey,
            ),
            onPressed: isEnabled ? onSend : null,
          ),
        ],
      ),
    );
  }
}
