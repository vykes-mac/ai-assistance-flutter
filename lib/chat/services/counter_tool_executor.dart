import '../../counter/cubit/counter_cubit.dart';
import '../models/tool_execution_result.dart';
import 'tool_executor.dart';

/// Implementation of ToolExecutor for counter-related tools
class CounterToolExecutor implements ToolExecutor {
  final CounterCubit _counterCubit;

  CounterToolExecutor({
    required CounterCubit counterCubit,
  }) : _counterCubit = counterCubit;

  @override
  List<String> get supportedTools => [
        'increment_counter',
        'decrement_counter',
        'reset_counter',
        'set_counter_value',
        'get_counter_history',
      ];

  @override
  ToolExecutionResult executeTool(String toolName, String? argsString) {
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
        return ToolExecutionResult.error('Unknown tool: $toolName');
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
  ToolExecutionResult _incrementCounter() {
    _counterCubit.increment();
    return ToolExecutionResult.success(
      message: 'Counter incremented by 1',
      action: 'incremented',
    );
  }

  /// Decrement the counter by 1
  ToolExecutionResult _decrementCounter() {
    _counterCubit.decrement();
    return ToolExecutionResult.success(
      message: 'Counter decremented by 1',
      action: 'decremented',
    );
  }

  /// Reset the counter to 0
  ToolExecutionResult _resetCounter() {
    _counterCubit.reset();
    return ToolExecutionResult.success(
      message: 'Counter reset to 0',
      action: 'reset',
    );
  }

  /// Set the counter to a specific value
  ToolExecutionResult _setCounterValue(int value) {
    _counterCubit.setValue(value);
    return ToolExecutionResult.success(
      message: 'Counter set to $value',
      action: 'set',
      value: value,
    );
  }

  /// Get the history of counter operations
  ToolExecutionResult _getCounterHistory() {
    final history = _counterCubit.state.history
        .map((op) => op.toString())
        .toList();
    
    return ToolExecutionResult.success(
      message: 'Retrieved ${history.length} history items',
      history: history,
    );
  }
}
