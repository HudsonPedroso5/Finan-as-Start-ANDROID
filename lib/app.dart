import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/screens/auth/login_screen.dart';
import 'package:fintracker/screens/main.screen.dart';
import 'package:fintracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final brightness = MediaQuery.platformBrightnessOf(context);
        final seedColor = Color(state.themeColor);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fintracker',
          themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light),
            navigationBarTheme: const NavigationBarThemeData(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
            navigationBarTheme: const NavigationBarThemeData(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            ),
          ),
          home: StreamBuilder<User?>(
            stream: AuthService.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData) {
                final cubit = context.read<AppCubit>();
                final firebaseUser = snapshot.data!;
                if (cubit.state.user?.uid != firebaseUser.uid) {
                  Future.microtask(() => cubit.syncFirebaseUser(firebaseUser));
                }
                return const MainScreen();
              }
              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
