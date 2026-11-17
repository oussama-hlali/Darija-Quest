enum StatutMot { nouveau, connu, aRevoir }

extension StatutMotX on StatutMot {
  /// Étiquette affichée dans la liste des mots d'un thème.
  String get etiquette => switch (this) {
    StatutMot.nouveau => 'Nouveau',
    StatutMot.connu => '✓ Connu',
    StatutMot.aRevoir => '↺ À revoir',
  };
}

class Mot {
  final int id;
  final String darija;
  final String arabe;
  final String francais;
  final String niveau;
  final String exemple;
  final String exemplefr;

  StatutMot statut;
  bool favori;

  Mot({
    required this.id,
    required this.darija,
    this.arabe = '',
    required this.francais,
    required this.niveau,
    this.exemple = '',
    this.exemplefr = '',
    this.statut = StatutMot.nouveau,
    this.favori = false,
  });
}
