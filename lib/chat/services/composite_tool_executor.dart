import '../models/tool_execution_result.dart';
import 'tool_executor.dart';

/// Composite tool executor that delegates to multiple executors
class CompositeToolExecutor implements ToolExecutor {
  final List<ToolExecutor> _executors;

  CompositeToolExecutor({required List<ToolExecutor> executors})
    : _executors = executors;

  @override
  List<String> get supportedTools {
    return _executors.expand((executor) => executor.supportedTools).toList();
  }

  @override
  ToolExecutionResult executeTool(String toolName, String? argsString) {
    // Find the executor that supports this tool
    for (final executor in _executors) {
      if (executor.supportedTools.contains(toolName)) {
        return executor.executeTool(toolName, argsString);
      }
    }

    return ToolExecutionResult.error('No executor found for tool: $toolName');
  }
}
