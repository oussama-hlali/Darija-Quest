import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// Palette du design.
class Couleurs {
  /// Fond général de l'application.
  static const fond = Color(0xFFF4F8F9);

  /// Texte principal (presque noir, bleuté).
  static const encre = Color(0xFF172E36);

  /// Texte secondaire.
  static const encreDoux = Color(0xFF455D66);

  /// Texte estompé (icônes non sélectionnées, indices).
  static const estompe = Color(0xFF73878E);

  /// Bleu « clair » de la marque.
  static const primaire = Color(0xFF1B6F8A);

  /// Rouge d'erreur.
  static const erreur = Color(0xFFBA1A1A);

  /// Terracotta — couleur de réussite dans la maquette.
  static const terreCuite = Color(0xFF964D40);

  /// Surface des rangées internes, presque blanche.
  static const chip = Color(0xFFF7FAF9);

  /// Les trois taches pastel derrière le verre.
  static const peche = Color(0xFFFFDAD1);
  static const sable = Color(0xFFF3DFC5);
  static const ciel = Color(0xFFBCE9F8);
}

/// Texte latin
TextStyle txt(
  double taille, {
  FontWeight graisse = FontWeight.w400,
  Color couleur = Couleurs.encre,
  double? espacement,
  double? hauteur,
}) => TextStyle(
  fontSize: taille,
  fontWeight: graisse,
  color: couleur,
  letterSpacing: espacement,
  height: hauteur,
);

/// Texte en écriture arabe (police livrée dans assets/fonts).
TextStyle txtArabe(
  double taille, {
  FontWeight graisse = FontWeight.w600,
  Color couleur = Couleurs.encre,
}) => TextStyle(
  fontSize: taille,
  fontWeight: graisse,
  color: couleur,
  fontFamily: 'NotoSansArabic',
  height: 1.3,
);

class FondVerre extends StatelessWidget {
  const FondVerre({super.key});

  /// Une tache floutée, positionnée sur la grille 360×800 du design
  /// puis étirée à la taille réelle de l'écran.
  Widget _tache(
    double cx,
    double cy,
    double rx,
    double ry,
    Color couleur,
    double opacite,
    double sx,
    double sy,
  ) {
    return Positioned(
      left: (cx - rx) * sx,
      top: (cy - ry) * sy,
      width: rx * 2 * sx,
      height: ry * 2 * sy,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: Opacity(
          opacity: opacite,
          child: DecoratedBox(
            decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, contraintes) {
      final sx = contraintes.maxWidth / 360;
      final sy = contraintes.maxHeight / 800;
      return ClipRect(
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Couleurs.fond)),
            _tache(65, 710, 195, 190, Couleurs.peche, .65, sx, sy),
            _tache(330, 430, 190, 210, Couleurs.sable, .80, sx, sy),
            _tache(100, 225, 210, 215, Couleurs.ciel, .85, sx, sy),
          ],
        ),
      );
    },
  );
}

/// Bordure 1 px dégradée blanc 60 % → 10 % (haut-gauche vers bas-droite),
/// exactement comme dans la maquette.
class _BordVerre extends CustomPainter {
  const _BordVerre(this.rayon);
  final double rayon;

  @override
  void paint(Canvas canvas, Size taille) {
    final rect = Offset.zero & taille;
    final rr = RRect.fromRectAndRadius(
      rect.deflate(.5),
      Radius.circular(rayon - .5),
    );
    canvas.drawRRect(
      rr,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .6),
            Colors.white.withValues(alpha: .1),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _BordVerre ancien) => ancien.rayon != rayon;
}

/// Panneau de verre.
///
/// [remplissage] : opacité du voile blanc — .30 pour un verre fort
/// (barres, cartes principales), .18 pour un verre courant,
/// .06 pour un verre fin (champ de recherche).
class Verre extends StatelessWidget {
  const Verre({
    super.key,
    required this.child,
    this.rayon = 28,
    this.remplissage = .18,
    this.margeInterne,
    this.hauteur,
    this.teinte,
  });

  final Widget child;
  final double rayon;
  final double remplissage;
  final EdgeInsetsGeometry? margeInterne;
  final double? hauteur;
  final Color? teinte;

  @override
  Widget build(BuildContext context) {
    final bords = BorderRadius.circular(rayon);
    return Container(
      height: hauteur,
      decoration: BoxDecoration(
        borderRadius: bords,
        boxShadow: [
          BoxShadow(
            color: Couleurs.encre.withValues(alpha: .10), // 0x19172E36
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: bords,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: CustomPaint(
            foregroundPainter: _BordVerre(rayon),
            child: Container(
              color: (teinte ?? Colors.white).withValues(alpha: remplissage),
              padding: margeInterne,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Décoration « pastille interne » : #F7FAF9 à 66 %, coins arrondis —
/// utilisée pour les rangées de listes et les champs de formulaire.
BoxDecoration boiteChip(
  double rayon, {
  Color? couleur,
  Color? bord,
  double epaisseur = 1,
}) => BoxDecoration(
  color: couleur ?? Couleurs.chip.withValues(alpha: .66),
  borderRadius: BorderRadius.circular(rayon),
  border: bord == null ? null : Border.all(color: bord, width: epaisseur),
);

/// Pastille bleutée (compteur de série, score du quiz…).
class Pastille extends StatelessWidget {
  const Pastille(
    this.child, {
    super.key,
    this.opacite = .094,
    this.largeurMin = 0,
  });
  final Widget child;
  final double opacite;
  final double largeurMin;

  @override
  Widget build(BuildContext context) => Container(
    height: 36,
    constraints: BoxConstraints(minWidth: largeurMin),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Couleurs.primaire.withValues(alpha: opacite),
      borderRadius: BorderRadius.circular(18),
    ),
    child: child,
  );
}

/// Barre supérieure en verre : bouton retour optionnel, titre, zone à droite.
class BarreHaute extends StatelessWidget {
  const BarreHaute(
    this.titre, {
    super.key,
    this.retour = false,
    this.droite,
    this.tailleTitre = 18,
  });
  final String titre;
  final bool retour;
  final Widget? droite;
  final double tailleTitre;

  @override
  Widget build(BuildContext context) => Verre(
    rayon: 32,
    remplissage: .30,
    hauteur: 60,
    margeInterne: EdgeInsets.only(left: 8, right: 12),
    child: Row(
      children: [
        if (retour)
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Couleurs.encre, size: 24),
            onPressed: () => Navigator.maybePop(context),
          )
        else
          const SizedBox(width: 12),
        Expanded(
          child: Text(titre, style: txt(tailleTitre, graisse: FontWeight.w600)),
        ),
        ?droite,
      ],
    ),
  );
}

/// Squelette de page : fond liquide + barre haute + corps + bandeau bas,
/// avec les marges sûres du système (encoche, barre de navigation).
class PageVerre extends StatelessWidget {
  const PageVerre({
    super.key,
    required this.corps,
    this.haut,
    this.bas,
    this.calque,
  });
  final Widget corps;
  final Widget? haut;
  final Widget? bas;
  final Widget? calque;

  @override
  Widget build(BuildContext context) {
    final marges = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: Couleurs.fond,
      body: Stack(
        children: [
          const Positioned.fill(child: FondVerre()),
          Column(
            children: [
              if (haut != null) ...[
                SizedBox(height: marges.top + 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: haut,
                ),
              ] else
                SizedBox(height: marges.top + 12),
              Expanded(child: corps),
              if (bas != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: bas!,
                ),
              SizedBox(height: math.max(marges.bottom, 12)),
            ],
          ),
          ?calque,
        ],
      ),
    );
  }
}

/// Gros bouton plein (primaire) ou doux ([doux] = teinte bleutée 12,5 %).
class BoutonPrincipal extends StatelessWidget {
  const BoutonPrincipal(
    this.libelle, {
    super.key,
    required this.surTap,
    this.icone,
    this.doux = false,
  });
  final String libelle;
  final VoidCallback surTap;
  final IconData? icone;
  final bool doux;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: surTap,
    child: Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: doux
            ? Couleurs.primaire.withValues(alpha: .125)
            : Couleurs.primaire,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 22, color: doux ? Couleurs.encre : Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            libelle,
            style: txt(
              14,
              graisse: FontWeight.w600,
              couleur: doux ? Couleurs.encre : Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Anneau de progression (pourcentage de mots connus).
class Anneau extends StatelessWidget {
  const Anneau({
    super.key,
    required this.taille,
    required this.trait,
    required this.valeur,
    this.couleur = Couleurs.primaire,
    this.child,
  });

  final double taille;
  final double trait;
  final double valeur;
  final Color couleur;
  final Widget? child;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: taille,
    height: taille,
    child: CustomPaint(
      painter: _AnneauPeintre(valeur, trait, couleur),
      child: Center(child: child),
    ),
  );
}

class _AnneauPeintre extends CustomPainter {
  const _AnneauPeintre(this.valeur, this.trait, this.couleur);
  final double valeur;
  final double trait;
  final Color couleur;

  @override
  void paint(Canvas canvas, Size taille) {
    final rect = Rect.fromLTWH(
      trait / 2,
      trait / 2,
      taille.width - trait,
      taille.height - trait,
    );
    final pinceau = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trait
      ..strokeCap = StrokeCap.round;
    // Piste : même couleur, à 25 % d'opacité.
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      pinceau..color = couleur.withValues(alpha: .25),
    );
    // Progression : départ à midi, sens des aiguilles.
    if (valeur > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * valeur.clamp(0, 1),
        false,
        pinceau..color = couleur,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnneauPeintre ancien) =>
      ancien.valeur != valeur ||
      ancien.trait != trait ||
      ancien.couleur != couleur;
}

/// Grande icône dans sa boîte arrondie (états vides, erreurs).
class BoiteIcone extends StatelessWidget {
  const BoiteIcone(this.icone, {super.key, this.couleur = Couleurs.primaire});
  final IconData icone;
  final Color couleur;

  @override
  Widget build(BuildContext context) => Container(
    width: 72,
    height: 72,
    decoration: BoxDecoration(
      color: Couleurs.primaire.withValues(alpha: .094),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Icon(icone, size: 32, color: couleur),
  );
}
