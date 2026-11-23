import 'package:flutter_test/flutter_test.dart';

import 'package:darija_quest/services/validation_form.dart';

/// Tests de la validation du formulaire (EF3), sans appel réseau.
void main() {
  test('un champ vide est refusé', () {
    expect(
      champObligatoire('', 'Le mot en darija'),
      'Le mot en darija est obligatoire',
    );
    expect(
      champObligatoire('   ', 'Le mot en darija'),
      'Le mot en darija est obligatoire',
    );
  });

  test('un champ rempli est accepté', () {
    expect(champObligatoire('Sa7bi', 'Le mot en darija'), isNull);
  });

  test('seuls les trois niveaux sont acceptés', () {
    expect(niveauValide('Débutant'), isTrue);
    expect(niveauValide('Intermédiaire'), isTrue);
    expect(niveauValide('Avancé'), isTrue);
    expect(niveauValide('Expert'), isFalse);
  });
}
