import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mot.dart';
import '../providers/favoris_provider.dart';
import '../models/theme_darija.dart';
import '../services/api_service.dart';
import 'theme_detail_screen.dart';

/// Accueil : les thèmes sont construits à partir des mots de l'API.
class AcceuilScreen extends StatefulWidget {
  const AcceuilScreen({super.key});

  @override
  State<AcceuilScreen> createState() => _AcceuilScreenState();
}

class _AcceuilScreenState extends State<AcceuilScreen> {
  late Future<List<Mot>> _motsFuturs = ApiService.getMots();

  static const _icones = <IconData>[
    Icons.waving_hand,
    Icons.restaurant,
    Icons.home,
    Icons.favorite,
    Icons.school,
  ];

  void _recharger() {
    setState(() => _motsFuturs = ApiService.getMots());
  }

  /// Regroupe les mots reçus par thème.
  List<ThemeDarija> _grouper(List<Mot> mots) {
    final noms = <String>[];
    for (final mot in mots) {
      if (!noms.contains(mot.theme)) noms.add(mot.theme);
    }

    return [
      for (var i = 0; i < noms.length; i++)
        ThemeDarija(
          nom: noms[i],
          icone: _icones[i % _icones.length],
          mots: mots.where((m) => m.theme == noms[i]).toList(),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final favoris = context.watch<FavorisProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Darija Quest'),
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
          if (mots.isEmpty) {
            return const Center(
              child: Text('Aucun mot pour le moment. Ajoutez-en un avec +.'),
            );
          }

          final themes = _grouper(mots);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: themes.length,
            itemBuilder: (context, i) {
              final t = themes[i];
              final nbFavoris = favoris.totalPour(
                t.mots.map((m) => m.id).toList(),
              );
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(t.icone, color: c.primary),
                  title: Text(
                    t.nom,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text('${t.mots.length} mots'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (nbFavoris > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            '$nbFavoris',
                            style: TextStyle(color: c.primary),
                          ),
                        ),
                      Icon(
                        nbFavoris > 0 ? Icons.favorite : Icons.favorite_border,
                        color: c.primary,
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ThemeDetailScreen(theme: t),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
