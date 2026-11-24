import 'package:flutter/foundation.dart';

class FavorisProvider extends ChangeNotifier {
  final Set<int> _ids = <int>{};

  /// Copie en lecture seule pour ne pas modifier l'état depuis l'extérieur.
  Set<int> get ids => Set<int>.unmodifiable(_ids);

  bool estFavori(int id) => _ids.contains(id);

  /// Ajoute ou retire un mot, puis prévient les écrans abonnés.
  void basculer(int id) {
    if (!_ids.add(id)) {
      _ids.remove(id);
    }
    notifyListeners();
  }

  int totalPour(List<int> identifiants) {
    return identifiants.where(estFavori).length;
  }
}
