import 'package:flutter/material.dart';

import '../models/mot.dart';
import '../services/api_service.dart';

/// Statistiques calculées à partir des mots renvoyés par l'API.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<List<Mot>> _motsFuturs = ApiService.getMots();
  late Future<List<ThemeStat>> _themesFuturs = ApiService.getThemes();

  void _recharger() {
    setState(() {
      _motsFuturs = ApiService.getMots();
      _themesFuturs = ApiService.getThemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            onPressed: _recharger,
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: FutureBuilder<List<Mot>>(
        future: _motsFuturs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Erreur : ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _recharger,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final mots = snapshot.data ?? [];
          final parNiveau = <String, int>{};
          for (final mot in mots) {
            parNiveau[mot.niveau] = (parNiveau[mot.niveau] ?? 0) + 1;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '${mots.length}',
                              style: theme.textTheme.headlineMedium,
                            ),
                            const Text('mots'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '${parNiveau.length}',
                              style: theme.textTheme.headlineMedium,
                            ),
                            const Text('niveaux'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mots par niveau',
                        style: theme.textTheme.titleMedium,
                      ),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mots par thème',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<List<ThemeStat>>(
                        future: _themesFuturs,
                        builder: (context, snapThemes) {
                          if (snapThemes.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(8),
                              child: LinearProgressIndicator(),
                            );
                          }
                          if (snapThemes.hasError) {
                            return Text('Erreur : ${snapThemes.error}');
                          }
                          final stats = snapThemes.data ?? [];
                          if (stats.isEmpty) {
                            return const Text('Aucune statistique.');
                          }
                          return Column(
                            children: [
                              for (final s in stats)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.category,
                                        size: 20,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(s.nom)),
                                      Text('${s.total}'),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
