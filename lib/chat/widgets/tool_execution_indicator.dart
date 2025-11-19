import 'package:flutter/material.dart';

/// Widget that shows when a tool is being executed
class ToolExecutionIndicator extends StatelessWidget {
  final String executionMessage;

  const ToolExecutionIndicator({
    super.key,
    required this.executionMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      color: Colors.blue.shade100,
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(executionMessage),
        ],
      ),
    );
  }
}
