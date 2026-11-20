import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:darija_quest/data/donnees_fictives.dart';
import 'package:darija_quest/main.dart';
import 'package:darija_quest/screens/theme_detail_screen.dart';

void main() {
  testWidgets('l accueil affiche les thèmes', (tester) async {
    await tester.pumpWidget(const DarijaQuestApp());

    expect(find.text('Darija Quest'), findsOneWidget);
    for (final t in themes) {
      expect(find.text(t.nom), findsWidgets);
    }
  });

  testWidgets('toucher un thème ouvre le détail', (tester) async {
    await tester.pumpWidget(const DarijaQuestApp());

    await tester.tap(find.text(themes.first.nom).first);
    await tester.pumpAndSettle();

    expect(find.byType(ThemeDetailScreen), findsOneWidget);
  });

  testWidgets('le bouton + ouvre le formulaire', (tester) async {
    await tester.pumpWidget(const DarijaQuestApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Ajouter un mot'), findsOneWidget);
  });
}
