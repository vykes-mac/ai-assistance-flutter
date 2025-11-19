import '../../counter/cubit/counter_cubit.dart';
import '../models/tool_execution_result.dart';
import 'tool_executor.dart';

/// Implementation of ToolExecutor for counter-related tools
class CounterToolExecutor implements ToolExecutor {
  final CounterCubit _counterCubit;

  CounterToolExecutor({required CounterCubit counterCubit})
    : _counterCubit = counterCubit;

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
        if (!args.containsKey('value')) {
          return ToolExecutionResult.error(
            'No value provided for set_counter_value',
          );
        }
        // Try to get the value and convert it properly
        dynamic rawValue = args['value'];
        int value;

        if (rawValue is int) {
          value = rawValue;
        } else if (rawValue is double) {
          value = rawValue.toInt();
        } else if (rawValue is String) {
          value = int.tryParse(rawValue) ?? 0;
        } else {
          value = 0;
        }

        final result = _setCounterValue(value);
        return result;

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
      final colonIndex = pair.indexOf(':');
      if (colonIndex != -1) {
        final key = pair.substring(0, colonIndex).trim();
        final value = pair.substring(colonIndex + 1).trim();

        // Try to parse as int, then double, otherwise keep as string
        final intValue = int.tryParse(value);
        if (intValue != null) {
          args[key] = intValue;
        } else {
          final doubleValue = double.tryParse(value);
          args[key] = doubleValue ?? value;
        }
      }
    }

    return args;
  }

  /// Increment the counter by 1
  ToolExecutionResult _incrementCounter() {
    _counterCubit.increment();
    final newValue = _counterCubit.state.value;
    return ToolExecutionResult.success(
      message: 'Counter incremented. New value: $newValue',
      action: 'incremented',
      value: newValue,
    );
  }

  /// Decrement the counter by 1
  ToolExecutionResult _decrementCounter() {
    _counterCubit.decrement();
    final newValue = _counterCubit.state.value;
    return ToolExecutionResult.success(
      message: 'Counter decremented. New value: $newValue',
      action: 'decremented',
      value: newValue,
    );
  }

  /// Reset the counter to 0
  ToolExecutionResult _resetCounter() {
    _counterCubit.reset();
    final newValue = _counterCubit.state.value;
    return ToolExecutionResult.success(
      message: 'Counter reset. New value: $newValue',
      action: 'reset',
      value: newValue,
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
