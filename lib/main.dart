import 'package:flutter/material.dart';

import 'screens/app_shell.dart';

void main() => runApp(const DarijaQuestApp());

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
