import 'package:fintracker/app.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (_) => AppCubit(),
      child: const App(),
    ),
  );
}
