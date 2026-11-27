import 'package:shared_preferences/shared_preferences.dart';

/// Persistance locale des favoris (EF7).
///
/// Les identifiants sont gardés sous forme de texte pour rester simples.
class FavorisStorage {
  static const _cle = 'favoris_ids';

  /// Relit les favoris de la session précédente, ou une liste vide.
  static Future<List<int>> charger() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_cle)?.map(int.parse).toList() ?? <int>[];
  }

  /// Écrase la sauvegarde avec l'état actuel.
  static Future<void> enregistrer(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final ordonnes = ids.toList()..sort();
    await prefs.setStringList(_cle, ordonnes.map((id) => '$id').toList());
  }
}
