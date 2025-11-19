import 'package:equatable/equatable.dart';

import '../models/counter_operation.dart';

/// State for the counter feature
class CounterState extends Equatable {
  final int value;
  final List<CounterOperation> history;

  const CounterState({
    required this.value,
    required this.history,
  });

  /// Initial state with counter at 0 and empty history
  const CounterState.initial()
      : value = 0,
        history = const [];

  /// Create a copy of the state with updated values
  CounterState copyWith({
    int? value,
    List<CounterOperation>? history,
  }) {
    return CounterState(
      value: value ?? this.value,
      history: history ?? this.history,
    );
  }

  @override
  List<Object> get props => [value, history];
}
