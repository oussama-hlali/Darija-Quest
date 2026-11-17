import 'package:flutter/material.dart';

import '../data/donnees_fictives.dart';
import '../models/theme_darija.dart';
import '../widgets/verre.dart';
import 'theme_detail_screen.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  final _recherche = TextEditingController();
  int _niveau = 0; // 0 = Tous, 1 = Débutant, 2 = Intermédiaire, 3 = Avancé

  static const _niveaux = ['Tous', 'Débutant', 'Intermédiaire', 'Avancé'];

  @override
  void dispose() {
    _recherche.dispose();
    super.dispose();
  }

  /// Thèmes visibles après la recherche et le filtre de niveau.
  List<ThemeDarija> get _visibles {
    final q = _recherche.text.trim().toLowerCase();
    return themes.where((t) {
      return t.mots.any((m) {
        final niveauOk = _niveau == 0 || m.niveau == _niveaux[_niveau];
        final rechercheOk =
            q.isEmpty ||
            m.darija.toLowerCase().contains(q) ||
            m.francais.toLowerCase().contains(q) ||
            m.arabe.contains(q) ||
            t.nom.toLowerCase().contains(q);
        return niveauOk && rechercheOk;
      });
    }).toList();
  }

  Future<void> _ouvrirTheme(ThemeDarija t) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ThemeDetailScreen(theme: t)),
    );
    // Au retour (après une étude), on relit les statuts des mots.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _visibles;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: BarreHaute(
            'Darija Quest',
            droite: Pastille(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '$serieJours jours',
                    style: txt(14, graisse: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: visibles.isEmpty
              ? ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  children: [_etatVide()],
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  children: [
                    Text(
                      'Chwaya, chaque jour.',
                      style: txt(
                        24,
                        graisse: FontWeight.w600,
                        hauteur: 28 / 24,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Un peu de darija, beaucoup de liens.',
                      style: txt(
                        14,
                        couleur: Couleurs.encreDoux,
                        hauteur: 20 / 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _champRecherche(),
                    const SizedBox(height: 12),
                    _filtresNiveau(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'À vous de parler',
                          style: txt(20, graisse: FontWeight.w600),
                        ),
                        Text(
                          '${visibles.length} thèmes',
                          style: txt(12, couleur: Couleurs.encreDoux),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    _carteThemes(visibles),
                  ],
                ),
        ),
      ],
    );
  }

  /// Champ de recherche — verre fin (voile encre 6 %, bord blanc 40 %).
  Widget _champRecherche() => Container(
    height: 48,
    decoration: BoxDecoration(
      color: Couleurs.encre.withValues(alpha: .06),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: .4)),
    ),
    child: Row(
      children: [
        const SizedBox(width: 16),
        const Icon(Icons.search, size: 24, color: Couleurs.encre),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _recherche,
            onChanged: (_) => setState(() {}),
            cursorColor: Couleurs.primaire,
            style: txt(16, couleur: Couleurs.encre),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: 'Rechercher un mot...',
              hintStyle: txt(16, couleur: Couleurs.encreDoux),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    ),
  );

  /// Puces de filtre par niveau (Tous / Débutant / … / Avancé).
  Widget _filtresNiveau() => SizedBox(
    height: 48,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _niveaux.length,
      separatorBuilder: (_, _) => const SizedBox(width: 4),
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => setState(() => _niveau = i),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: i == _niveau
                ? Couleurs.primaire.withValues(alpha: .125)
                : Couleurs.chip.withValues(alpha: .66),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            _niveaux[i],
            style: txt(
              13,
              graisse: FontWeight.w500,
              couleur: i == _niveau ? Couleurs.encre : Couleurs.encreDoux,
            ),
          ),
        ),
      ),
    ),
  );

  /// Grande carte de verre contenant la liste des thèmes.
  Widget _carteThemes(List<ThemeDarija> visibles) => Verre(
    rayon: 28,
    remplissage: .18,
    margeInterne: const EdgeInsets.all(8),
    child: Column(
      children: [
        for (var i = 0; i < visibles.length; i++) ...[
          if (i > 0) const SizedBox(height: 4),
          _rangeeTheme(visibles[i]),
        ],
      ],
    ),
  );

  /// Une rangée de thème : icône, nom, nombre de mots, anneau de
  /// progression (« 50 % » = moitié des mots connus).
  Widget _rangeeTheme(ThemeDarija t) {
    final p = t.progression;
    return GestureDetector(
      onTap: () => _ouvrirTheme(t),
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(left: 12, right: 8),
        decoration: boiteChip(20),
        child: Row(
          children: [
            Icon(t.icone, size: 26, color: Couleurs.primaire),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.nom,
                    style: txt(16, graisse: FontWeight.w600, hauteur: 20 / 16),
                  ),
                  Text(
                    '${t.mots.length} mots',
                    style: txt(
                      13,
                      couleur: Couleurs.encreDoux,
                      hauteur: 18 / 13,
                    ),
                  ),
                ],
              ),
            ),
            Anneau(
              taille: 44,
              trait: 4,
              valeur: p,
              child: Text(
                '${(p * 100).round()}%',
                style: txt(12, graisse: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// État vide : la recherche ne renvoie aucun mot.
  Widget _etatVide() => Verre(
    rayon: 28,
    remplissage: .18,
    margeInterne: const EdgeInsets.fromLTRB(16, 40, 16, 16),
    child: Column(
      children: [
        const BoiteIcone(Icons.search),
        const SizedBox(height: 24),
        Text(
          'Aucun résultat',
          style: txt(20, graisse: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Essayez un autre mot en darija ou en français.',
          style: txt(15, couleur: Couleurs.encreDoux, hauteur: 22 / 15),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}
