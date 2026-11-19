import 'package:material_ui/material_ui.dart';

import '../widgets/verre.dart';
import 'acceuil_screen.dart';
import 'ajouter_mot_screen.dart';
import 'quiz_screen.dart';
import 'stats_screen.dart';

/// Coquille de l'application : barre de navigation inférieure entre
/// Accueil, Quiz et Statistiques.
///
/// Jalon J1 : seul un `setState` gère l'onglet actif — aucun état
/// global (pas de Provider), conformément au brief.
/// Le bouton « + » n'apparaît que sur l'onglet Accueil.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _ongletActif = 0;

  Widget _onglet(IconData icone, String label, int index) {
    final c = Theme.of(context).colorScheme;
    final actif = _ongletActif == index;

    return GestureDetector(
      onTap: () => setState(() => _ongletActif = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: actif ? c.primary.withValues(alpha: .12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, color: actif ? c.primary : c.onSurfaceVariant),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: actif ? c.onSurface : c.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _ongletActif,
        children: const [AccueilScreen(), QuizScreen(), StatsScreen()],
      ),
      floatingActionButton: _ongletActif == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AjouterMotScreen()),
              ),
              backgroundColor: c.primary,
              foregroundColor: c.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Verre(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _onglet(Icons.menu_book, 'Accueil', 0),
              _onglet(Icons.lightbulb, 'Quiz', 1),
              _onglet(Icons.bar_chart, 'Statistiques', 2),
            ],
          ),
        ),
      ),
    );
  }
}
