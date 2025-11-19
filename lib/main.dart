import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'counter/cubit/counter_cubit.dart';

void main() {
  runApp(BlocProvider(create: (context) => CounterCubit(), child: const App()));
}
