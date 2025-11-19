import 'package:equatable/equatable.dart';

/// Represents a single operation performed on the counter
class CounterOperation extends Equatable {
  final String action;
  final DateTime timestamp;
  final int? value;

  const CounterOperation({
    required this.action,
    required this.timestamp,
    this.value,
  });

  @override
  List<Object?> get props => [action, timestamp, value];

  @override
  String toString() {
    if (value != null) {
      return '$action (value: $value)';
    }
    return action;
  }
}
