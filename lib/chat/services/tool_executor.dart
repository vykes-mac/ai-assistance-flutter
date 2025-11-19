import '../models/tool_execution_result.dart';

/// Abstract interface for executing tools
abstract class ToolExecutor {
  /// Execute a tool by name with the provided arguments
  ToolExecutionResult executeTool(String toolName, String? argsString);

  /// Get the list of supported tool names
  List<String> get supportedTools;
}
