import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/screens/main.screen.dart';
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
          home: const MainScreen(),
        );
      },
    );
  }
}
