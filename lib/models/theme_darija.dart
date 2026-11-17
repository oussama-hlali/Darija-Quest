import 'package:flutter/material.dart';

import 'mot.dart';

class ThemeDarija {
  final String nom;
  final IconData icone;
  final List<Mot> mots;

  const ThemeDarija({
    required this.nom,
    required this.icone,
    required this.mots,
  });

  /// Niveau affiché pour le thème (celui de ses mots).
  String get niveau => mots.isEmpty ? 'Débutant' : mots.first.niveau;

  /// Nombre de mots marqués « connu ».
  int get nbConnus => mots.where((m) => m.statut == StatutMot.connu).length;

  /// Progression du thème, entre 0 et 1 — anneau de l'accueil
  /// (« 50 % ») et grande jauge du détail.
  double get progression => mots.isEmpty ? 0 : nbConnus / mots.length;
}
