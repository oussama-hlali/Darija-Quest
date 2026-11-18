import 'package:material_ui/material_ui.dart';

import '../models/theme_darija.dart';
import '../models/theme_darija.dart';
import '../widgets/verre.dart';
import 'etude_screen.dart';
import 'quiz_screen.dart';

import 'package:darija_quest/models/mot.dart';

class ThemeDetailScreen extends StatelessWidget {
  const ThemeDetailScreen({super.key, required this.theme});

  final ThemeDarija theme;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return PageVerre(
      titre: theme.nom,
      retour: true,
      enfant: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Verre(
            child: Row(
              children: [
                Icon(theme.icone, size: 32, color: c.primary),
                const SizedBox(width: 12),
                Text(
                  '${theme.mots.length} mots',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final Mot mot in theme.mots)
            Verre(
              child: ListTile(
                title: Text(mot.darija),
                subtitle: Text('${mot.francais} · ${mot.niveau}'),
                trailing: Text(mot.arabe, style: const TextStyle(fontSize: 18)),
              ),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EtudeScreen(theme: theme)),
            ),
            icon: const Icon(Icons.school),
            label: const Text("Commencer l'étude"),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QuizScreen(theme: theme)),
            ),
            icon: const Icon(Icons.lightbulb),
            label: const Text('Faire le quiz'),
          ),
        ],
      ),
    );
  }
}
