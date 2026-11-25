import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favoris_provider.dart';
import 'screens/app_shell.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavorisProvider(),
      child: const DarijaQuestApp(),
    ),
  );
}

class DarijaQuestApp extends StatelessWidget {
  const DarijaQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darija Quest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B6F8A)),
      ),
      home: const AppShell(),
    );
  }
}
