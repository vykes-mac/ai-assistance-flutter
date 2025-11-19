/// Handler for executing tool calls from the AI assistant
class ToolHandler {
  final Function(int Function(int)) updateCounter;
  final List<String> history = [];

  ToolHandler({required this.updateCounter});

  /// Execute a tool by name with the provided arguments
  Map<String, dynamic> executeTool(String toolName, String? argsString) {
    // Parse arguments if provided
    final args = _parseArgs(argsString);

    switch (toolName) {
      case 'increment_counter':
        return _incrementCounter();

      case 'decrement_counter':
        return _decrementCounter();

      case 'reset_counter':
        return _resetCounter();

      case 'set_counter_value':
        final value = args['value'] as int? ?? 0;
        return _setCounterValue(value);

      case 'get_counter_history':
        return _getCounterHistory();

      default:
        return {'error': 'Unknown tool: $toolName'};
    }
  }

  /// Parse arguments string to map
  Map<String, dynamic> _parseArgs(String? argsString) {
    if (argsString == null || argsString.isEmpty) {
      return {};
    }

    // Parse format: "key1:value1,key2:value2"
    final args = <String, dynamic>{};
    final pairs = argsString.split(',');

    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();

        // Try to parse as int
        args[key] = int.tryParse(value) ?? value;
      }
    }

    return args;
  }

  /// Increment the counter by 1
  Map<String, dynamic> _incrementCounter() {
    updateCounter((current) => current + 1);
    history.add('Incremented by 1');
    return {
      'success': true,
      'action': 'incremented',
      'message': 'Counter incremented by 1',
    };
  }

  /// Decrement the counter by 1
  Map<String, dynamic> _decrementCounter() {
    updateCounter((current) => current - 1);
    history.add('Decremented by 1');
    return {
      'success': true,
      'action': 'decremented',
      'message': 'Counter decremented by 1',
    };
  }

  /// Reset the counter to 0
  Map<String, dynamic> _resetCounter() {
    updateCounter((_) => 0);
    history.add('Reset to 0');
    return {
      'success': true,
      'action': 'reset',
      'message': 'Counter reset to 0',
    };
  }

  /// Set the counter to a specific value
  Map<String, dynamic> _setCounterValue(int value) {
    updateCounter((_) => value);
    history.add('Set to $value');
    return {
      'success': true,
      'action': 'set',
      'value': value,
      'message': 'Counter set to $value',
    };
  }

  /// Get the history of counter operations
  Map<String, dynamic> _getCounterHistory() {
    return {
      'success': true,
      'history': history,
      'message': 'Retrieved ${history.length} history items',
    };
  }

  /// Clear the history
  void clearHistory() {
    history.clear();
  }

  /// Log an external action to history
  void logAction(String action) {
    history.add(action);
  }
}
