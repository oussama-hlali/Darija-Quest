import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mot.dart';
import '../models/theme_darija.dart';
import '../providers/favoris_provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import 'theme_detail_screen.dart';

/// Accueil : recherche, filtres, mode sombre et thèmes depuis l'API.
class AcceuilScreen extends StatefulWidget {
  const AcceuilScreen({super.key});

  @override
  State<AcceuilScreen> createState() => _AcceuilScreenState();
}

class _AcceuilScreenState extends State<AcceuilScreen> {
  late Future<List<Mot>> _motsFuturs = ApiService.getMots();
  final _recherche = TextEditingController();
  String? _niveau;

  static const _icones = <IconData>[
    Icons.waving_hand,
    Icons.restaurant,
    Icons.home,
    Icons.favorite,
    Icons.school,
  ];

  static const _niveaux = <String>['Débutant', 'Intermédiaire', 'Avancé'];

  @override
  void dispose() {
    _recherche.dispose();
    super.dispose();
  }

  /// Relance la requête avec les critères en cours (recherche + niveau).
  void _recharger() {
    setState(() {
      _motsFuturs = ApiService.getMots(
        recherche: _recherche.text.trim(),
        niveau: _niveau,
      );
    });
  }

  /// Un second clic sur le même niveau retire le filtre.
  void _changerNiveau(String niveau) {
    setState(() {
      _niveau = (_niveau == niveau) ? null : niveau;
      _motsFuturs = ApiService.getMots(
        recherche: _recherche.text.trim(),
        niveau: _niveau,
      );
    });
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
    final sombre = context.watch<ThemeProvider>().mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Darija Quest'),
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeProvider>().basculer(),
            icon: Icon(sombre ? Icons.light_mode : Icons.dark_mode),
            tooltip: sombre ? 'Mode clair' : 'Mode sombre',
          ),
          IconButton(
            onPressed: _recharger,
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _recherche,
              onSubmitted: (_) => _recharger(),
              decoration: InputDecoration(
                hintText: 'Rechercher un mot (ex. salam)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _recharger,
                  icon: const Icon(Icons.arrow_forward),
                  tooltip: 'Rechercher',
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final niveau in _niveaux)
                FilterChip(
                  label: Text(niveau),
                  selected: _niveau == niveau,
                  onSelected: (_) => _changerNiveau(niveau),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: FutureBuilder<List<Mot>>(
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
                    child: Text('Aucun mot ne correspond à ta recherche.'),
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
                    return Hero(
                      tag: 'theme-${t.nom}',
                      child: Card(
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
                                nbFavoris > 0
                                    ? Icons.favorite
                                    : Icons.favorite_border,
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
