import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Widget that displays the counter value
class CounterDisplay extends StatelessWidget {
  final int value;

  const CounterDisplay({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(AppConstants.counterDisplayText),
        Text(
          '$value',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
