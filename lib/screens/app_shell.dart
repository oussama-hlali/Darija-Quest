import 'package:flutter/material.dart';

import 'accueil_screen.dart';
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

  @override
  Widget build(BuildContext context) {
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
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _ongletActif,
        onDestinationSelected: (valeur) =>
            setState(() => _ongletActif = valeur),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.lightbulb), label: 'Quiz'),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
        ],
      ),
    );
  }
}
