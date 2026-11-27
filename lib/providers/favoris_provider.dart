import 'package:flutter/foundation.dart';

import '../services/favoris_storage.dart';

/// État partagé des favoris (EF5), conservé sur l'appareil (EF7).
class FavorisProvider extends ChangeNotifier {
  final Set<int> _ids = <int>{};

  /// Copie en lecture seule pour ne pas modifier l'état depuis l'extérieur.
  Set<int> get ids => Set<int>.unmodifiable(_ids);

  /// À appeler avant `runApp` pour retrouver les favoris précédents.
  Future<void> charger() async {
    _ids
      ..clear()
      ..addAll(await FavorisStorage.charger());
    notifyListeners();
  }

  bool estFavori(int id) => _ids.contains(id);

  /// Ajoute ou retire un mot, prévient les écrans et sauvegarde.
  Future<void> basculer(int id) async {
    if (!_ids.add(id)) {
      _ids.remove(id);
    }
    notifyListeners();
    await FavorisStorage.enregistrer(_ids);
  }

  int totalPour(List<int> identifiants) {
    return identifiants.where(estFavori).length;
  }
}
