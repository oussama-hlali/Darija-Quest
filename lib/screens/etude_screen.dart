import 'package:flutter/material.dart';

import '../models/mot.dart';
import '../models/theme_darija.dart';

/// Étude d'un thème : cartes recto/verso.
///
/// Jalon J1 : un `setState` retourne la carte touchée —
/// recto = darija + arabe, verso = traduction + exemples.
class EtudeScreen extends StatefulWidget {
  const EtudeScreen({super.key, required this.theme});

  final ThemeDarija theme;

  @override
  State<EtudeScreen> createState() => _EtudeScreenState();
}

class _EtudeScreenState extends State<EtudeScreen> {
  final Set<int> _retournees = <int>{};

  void _retourner(int index) {
    setState(() {
      if (!_retournees.remove(index)) {
        _retournees.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mots = widget.theme.mots;

    return Scaffold(
      appBar: AppBar(title: Text('Étude · ${widget.theme.nom}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${_retournees.length} / ${mots.length} cartes vues',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: mots.length,
              itemBuilder: (context, i) {
                final mot = mots[i];
                final visible = _retournees.contains(i);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _retourner(i),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: visible ? _verso(context, mot) : _recto(mot),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Face de la carte : le mot en darija et en arabe.
  Widget _recto(Mot mot) {
    return Column(
      key: const ValueKey('recto'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(mot.darija, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(mot.arabe, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        Text(
          'Touchez la carte pour voir la traduction',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  /// Dos de la carte : traduction et exemples.
  Widget _verso(BuildContext context, Mot mot) {
    final theme = Theme.of(context);
    return Column(
      key: const ValueKey('verso'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(mot.francais, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(mot.niveau, style: theme.textTheme.bodySmall),
        const Divider(height: 24),
        Text(mot.exemple, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          mot.exemplefr,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 12),
        Text(
          'Touchez la carte pour revenir au mot',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
