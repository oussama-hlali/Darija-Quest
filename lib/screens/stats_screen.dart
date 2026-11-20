import 'package:material_ui/material_ui.dart';

import '../data/donnees_fictives.dart';
import '../widgets/verre.dart';

/// Statistiques (jalon J1) calculées depuis les données fictives.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nbThemes = themes.length;
    final nbMots = themes.fold<int>(0, (total, t) => total + t.mots.length);

    final parNiveau = <String, int>{};
    for (final t in themes) {
      for (final mot in t.mots) {
        parNiveau[mot.niveau] = (parNiveau[mot.niveau] ?? 0) + 1;
      }
    }

    return PageVerre(
      titre: 'Statistiques',
      enfant: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Verre(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '$nbThemes',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const Text('thèmes'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Verre(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('$nbMots', style: theme.textTheme.headlineMedium),
                        const Text('mots'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Verre(
            grand: true,
            rayon: 28,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mots par niveau', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final niveau in parNiveau.keys)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text(niveau)),
                          Text('${parNiveau[niveau]}'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Verre(
            grand: true,
            rayon: 28,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mots par thème', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final t in themes)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            t.icone,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(t.nom)),
                          Text('${t.mots.length}'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
