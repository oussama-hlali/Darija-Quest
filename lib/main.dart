import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favoris_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final favoris = FavorisProvider();
  await favoris.charger();
  final theme = ThemeProvider();
  await theme.charger();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favoris),
        ChangeNotifierProvider.value(value: theme),
      ],
      child: const DarijaQuestApp(),
    ),
  );
}

class DarijaQuestApp extends StatelessWidget {
  const DarijaQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Darija Quest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B6F8A)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B6F8A),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: theme.mode,
      home: const AppShell(),
    );
  }
}
