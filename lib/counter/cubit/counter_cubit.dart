import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/counter_operation.dart';
import 'counter_state.dart';

/// Cubit that manages the counter state and operations
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState.initial());

  /// Increment the counter by 1
  void increment() {
    final newValue = state.value + 1;
    final operation = CounterOperation(
      action: 'Incremented by 1',
      timestamp: DateTime.now(),
    );
    emit(
      state.copyWith(value: newValue, history: [...state.history, operation]),
    );
  }

  /// Decrement the counter by 1
  void decrement() {
    final newValue = state.value - 1;
    final operation = CounterOperation(
      action: 'Decremented by 1',
      timestamp: DateTime.now(),
    );
    emit(
      state.copyWith(value: newValue, history: [...state.history, operation]),
    );
  }

  /// Reset the counter to 0
  void reset() {
    final operation = CounterOperation(
      action: 'Reset to 0',
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(value: 0, history: [...state.history, operation]));
  }

  /// Set the counter to a specific value
  void setValue(int value) {
    final operation = CounterOperation(
      action: 'Set to $value',
      timestamp: DateTime.now(),
      value: value,
    );
    emit(state.copyWith(value: value, history: [...state.history, operation]));
  }

  /// Add a custom operation to history without changing the value
  void logOperation(String action) {
    final operation = CounterOperation(
      action: action,
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(history: [...state.history, operation]));
  }

  /// Clear the operation history
  void clearHistory() {
    emit(state.copyWith(history: []));
  }
}
