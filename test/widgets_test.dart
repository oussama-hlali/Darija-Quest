import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:darija_quest/providers/favoris_provider.dart';
import 'package:darija_quest/widgets/bouton_favori.dart';

/// Tests de widgets (bonus) : le cœur réutilisable et le Provider.
Widget _app(FavorisProvider favoris) {
  return ChangeNotifierProvider<FavorisProvider>.value(
    value: favoris,
    child: const MaterialApp(
      home: Scaffold(body: Center(child: BoutonFavori(id: 1))),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('le coeur est vide au depart', (tester) async {
    await tester.pumpWidget(_app(FavorisProvider()));
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('un tap rend le coeur plein', (tester) async {
    final favoris = FavorisProvider();
    await tester.pumpWidget(_app(favoris));
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(favoris.estFavori(1), isTrue);
  });

  testWidgets('un second tap retire le favori', (tester) async {
    final favoris = FavorisProvider();
    await tester.pumpWidget(_app(favoris));
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(favoris.estFavori(1), isFalse);
  });
}
