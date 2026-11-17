import 'package:flutter/material.dart';

import '../models/theme_darija.dart';
import '../models/theme_darija.dart';
import '../widgets/verre.dart';
import 'etude_screen.dart';
import 'quiz_screen.dart';

import 'package:darija_quest/models/mot.dart';

class ThemeDetailScreen extends StatefulWidget {
  const ThemeDetailScreen({super.key, required this.theme});

  final ThemeDarija theme;

  @override
  State<ThemeDetailScreen> createState() => _ThemeDetailScreenState();
}

class _ThemeDetailScreenState extends State<ThemeDetailScreen> {
  /// Ouvre l'étude puis relit les statuts des mots au retour.
  Future<void> _commencerEtude() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EtudeScreen(theme: widget.theme)),
    );
    setState(() {});
  }

  Future<void> _faireQuiz() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizScreen(theme: widget.theme)),
    );
    setState(() {});
  }

  void _basculerCoeur(Mot mot) {
    setState(() => mot.favori = !mot.favori);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return PageVerre(
      haut: BarreHaute(t.nom, retour: true, tailleTitre: 20),
      corps: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          _carteEntete(t),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Les mots du thème',
                style: txt(16, graisse: FontWeight.w600),
              ),
              Text(
                '${t.mots.length} mots',
                style: txt(12, couleur: Couleurs.encreDoux),
              ),
            ],
          ),
          const SizedBox(height: 11),
          _listeMots(t),
          const SizedBox(height: 12),
          Text(
            'Un cœur pour garder vos mots préférés.',
            textAlign: TextAlign.center,
            style: txt(12, couleur: Couleurs.encreDoux),
          ),
        ],
      ),
    );
  }

  /// Carte d'en-tête en verre fort : anneau de progression, titre
  /// « X / N mots connus », puis les deux boutons d'action.
  Widget _carteEntete(ThemeDarija t) => Verre(
    rayon: 36,
    remplissage: .30,
    margeInterne: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          children: [
            Anneau(
              taille: 76,
              trait: 4,
              valeur: t.progression,
              child: Text(
                '${(t.progression * 100).round()}%',
                style: txt(13, graisse: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.nom.toUpperCase(),
                    style: txt(
                      12,
                      graisse: FontWeight.w500,
                      couleur: Couleurs.encreDoux,
                      espacement: .6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${t.nbConnus} / ${t.mots.length} mots connus',
                    style: txt(24, graisse: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        BoutonPrincipal(
          "Commencer l'étude",
          icone: Icons.auto_stories,
          surTap: _commencerEtude,
        ),
        const SizedBox(height: 8),
        BoutonPrincipal('Faire le quiz', doux: true, surTap: _faireQuiz),
      ],
    ),
  );

  /// Carte de verre courante contenant la liste des mots.
  Widget _listeMots(ThemeDarija t) => Verre(
    rayon: 28,
    remplissage: .18,
    margeInterne: const EdgeInsets.all(8),
    child: Column(
      children: [
        for (var i = 0; i < t.mots.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _rangeeMot(t.mots[i]),
        ],
      ],
    ),
  );

  /// Une rangée de mot : darija latin à gauche, écriture arabe à droite
  /// sur la même ligne, traduction, statut, puis le cœur de favori.
  Widget _rangeeMot(Mot mot) => Container(
    height: 94,
    padding: const EdgeInsets.only(left: 13, right: 0),
    decoration: boiteChip(20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      mot.darija,
                      style: txt(
                        16,
                        graisse: FontWeight.w600,
                        hauteur: 20 / 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Écriture arabe, alignée à droite sur la même ligne.
                  Text(mot.arabe, style: txtArabe(20, couleur: Couleurs.encre)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                mot.francais,
                style: txt(14, couleur: Couleurs.encreDoux, hauteur: 18 / 14),
              ),
              const SizedBox(height: 8),
              Text(
                mot.statut.etiquette,
                style: txt(
                  12,
                  graisse: FontWeight.w500,
                  couleur: _couleurStatut(mot.statut),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            onPressed: () => _basculerCoeur(mot),
            icon: Icon(
              mot.favori ? Icons.favorite : Icons.favorite_border,
              size: 26,
              color: mot.favori ? Couleurs.primaire : Couleurs.estompe,
            ),
          ),
        ),
      ],
    ),
  );

  Color _couleurStatut(StatutMot statut) => switch (statut) {
    StatutMot.connu => Couleurs.primaire,
    StatutMot.aRevoir => Couleurs.terreCuite,
    StatutMot.nouveau => Couleurs.estompe,
  };
}
