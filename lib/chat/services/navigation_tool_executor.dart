import '../../app.dart';
import '../models/tool_execution_result.dart';
import 'tool_executor.dart';

/// Implementation of ToolExecutor for navigation-related tools
class NavigationToolExecutor implements ToolExecutor {
  NavigationToolExecutor();

  @override
  List<String> get supportedTools => [
        'navigate_to_test_page',
      ];

  @override
  ToolExecutionResult executeTool(String toolName, String? argsString) {
    switch (toolName) {
      case 'navigate_to_test_page':
        return _navigateToTestPage();

      default:
        return ToolExecutionResult.error('Unknown tool: $toolName');
    }
  }

  /// Navigate to the test page
  ToolExecutionResult _navigateToTestPage() {
    try {
      final navigatorState = App.navigatorKey.currentState;
      if (navigatorState == null) {
        return ToolExecutionResult.error('Navigator not available');
      }
      navigatorState.pushNamed('/test');
      return ToolExecutionResult.success(
        message: 'Navigated to test page',
        action: 'navigated',
      );
    } catch (e) {
      return ToolExecutionResult.error('Failed to navigate: $e');
    }
  }
}
