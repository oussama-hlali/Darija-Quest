import 'package:flutter/material.dart';

import '../models/theme_darija.dart';

import 'package:darija_quest/models/mot.dart';

class ThemeDetailScreen extends StatelessWidget {
  const ThemeDetailScreen({super.key, required this.theme});

  final ThemeDarija theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(theme.nom)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Icon(
                theme.icone,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                '${theme.mots.length} mots',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final Mot mot in theme.mots)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(mot.darija),
                subtitle: Text('${mot.francais} · ${mot.niveau}'),
                trailing: Text(mot.arabe, style: const TextStyle(fontSize: 18)),
              ),
            ),
        ],
      ),
    );
  }
}
