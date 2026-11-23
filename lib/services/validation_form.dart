/// Validation simple du formulaire (EF3), sans accès réseau.
String? champObligatoire(String? valeur, String nom) {
  if (valeur == null || valeur.trim().isEmpty) {
    return '$nom est obligatoire';
  }
  return null;
}

/// Les seuls niveaux acceptés par l'API.
bool niveauValide(String niveau) {
  return const ['Débutant', 'Intermédiaire', 'Avancé'].contains(niveau);
}
