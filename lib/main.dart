import 'package:fintracker/app.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (_) => AppCubit(),
      child: const App(),
    ),
  );
}
