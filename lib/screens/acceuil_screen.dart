import 'package:flutter/material.dart';

import '../data/donnees_fictives.dart';
import '../models/theme_darija.dart';
import 'theme_detail_screen.dart';

class AcceuilScreen extends StatelessWidget {
  const AcceuilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Darija Quest")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: themes.length,
        itemBuilder: (context, i) {
          final ThemeDarija t = themes[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                t.icone,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(t.nom, style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text('${t.mots.length} mots'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ThemeDetailScreen(theme: t)),
              ),
            ),
          );
        },
      ),
    );
  }
}
