import 'package:equatable/equatable.dart';

/// Result of executing a tool
class ToolExecutionResult extends Equatable {
  final bool success;
  final String message;
  final String? action;
  final int? value;
  final List<String>? history;
  final String? error;

  const ToolExecutionResult({
    required this.success,
    required this.message,
    this.action,
    this.value,
    this.history,
    this.error,
  });

  /// Create a success result
  factory ToolExecutionResult.success({
    required String message,
    String? action,
    int? value,
    List<String>? history,
  }) {
    return ToolExecutionResult(
      success: true,
      message: message,
      action: action,
      value: value,
      history: history,
    );
  }

  /// Create an error result
  factory ToolExecutionResult.error(String error) {
    return ToolExecutionResult(
      success: false,
      message: error,
      error: error,
    );
  }

  /// Convert to map for serialization
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'success': success,
      'message': message,
    };
    if (action != null) map['action'] = action;
    if (value != null) map['value'] = value;
    if (history != null) map['history'] = history;
    if (error != null) map['error'] = error;
    return map;
  }

  @override
  List<Object?> get props => [success, message, action, value, history, error];
}
