import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/mot.dart';

/// Une seule adresse à changer si ton URL Render est différente.
const String baseUrl = 'https://darija-quest-api.onrender.com';

/// Une ligne renvoyée par GET /api/themes.
class ThemeStat {
  final String nom;
  final int total;

  const ThemeStat({required this.nom, required this.total});

  factory ThemeStat.fromJson(Map<String, dynamic> json) {
    return ThemeStat(
      nom: json['nom'] ?? 'Autres',
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Toutes les requêtes vers l'API Express déployée.
class ApiService {
  ApiService._();

  // Le plan gratuit Render s'endort : la 1re requête peut prendre ~30 s.
  static const Duration _delai = Duration(seconds: 60);

  /// Liste des mots, avec recherche et filtre par niveau (EF8).
  static Future<List<Mot>> getMots({
    String recherche = '',
    String? niveau,
  }) async {
    final uri = Uri.parse('$baseUrl/api/mots').replace(
      queryParameters: {
        if (recherche.trim().isNotEmpty) 'recherche': recherche.trim(),
        if (niveau != null && niveau.isNotEmpty) 'niveau': niveau,
      },
    );
    final reponse = await http.get(uri).timeout(_delai);

    if (reponse.statusCode != 200) {
      throw Exception('Chargement impossible (${reponse.statusCode})');
    }

    final liste = jsonDecode(reponse.body) as List<dynamic>;
    return liste.map((e) => Mot.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<ThemeStat>> getThemes() async {
    final reponse = await http
        .get(Uri.parse('$baseUrl/api/themes'))
        .timeout(_delai);

    if (reponse.statusCode != 200) {
      throw Exception('Statistiques indisponibles (${reponse.statusCode})');
    }

    final liste = jsonDecode(reponse.body) as List<dynamic>;
    return liste
        .map((e) => ThemeStat.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Object?> ajouterMot({
    required String darija,
    required String arabe,
    required String francais,
    required String niveau,
    required String exemple,
    required String exemplefr,
  }) async {
    final reponse = await http
        .post(
          Uri.parse('$baseUrl/api/mots'),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({
            'darija': darija,
            'arabe': arabe,
            'francais': francais,
            'niveau': niveau,
            'exemple': exemple,
            'exemplefr': exemplefr,
            'theme': 'Salutations',
          }),
        )
        .timeout(_delai);

    final corps = jsonDecode(reponse.body) as Map<String, dynamic>;

    if (reponse.statusCode == 201) {
      return Mot.fromJson(corps);
    }

    final erreurs = corps['erreurs'];
    if (erreurs is List && erreurs.isNotEmpty) {
      throw Exception(erreurs.join(' · '));
    }
    throw Exception('Enregistrement refusé (${reponse.statusCode})');
  }
}
