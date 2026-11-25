class Mot {
  final int id;
  final String darija;
  final String arabe;
  final String francais;
  final String niveau;
  final String exemple;
  final String exemplefr;
  final String theme;

  const Mot({
    required this.id,
    required this.darija,
    required this.arabe,
    required this.francais,
    required this.niveau,
    required this.exemple,
    required this.exemplefr,
    this.theme = 'Salutations',
  });

  factory Mot.fromJson(Map<String, dynamic> json) {
    return Mot(
      id: (json['id'] as num?)?.toInt() ?? 0,
      darija: json['darija'] ?? '',
      arabe: json['arabe'] ?? '',
      francais: json['francais'] ?? '',
      niveau: json['niveau'] ?? 'Débutant',
      exemple: json['exemple'] ?? '',
      exemplefr: json['exemplefr'] ?? '',
      theme: json['theme'] ?? 'Salutations',
    );
  }
}
