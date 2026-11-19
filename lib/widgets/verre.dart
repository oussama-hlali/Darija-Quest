import 'dart:ui';

import 'package:material_ui/material_ui.dart';

/// Fond du design Figma : trois blocs de couleur floutès derri├¿re le contenu.
class PageVerre extends StatelessWidget {
  const PageVerre({
    super.key,
    this.titre,
    required this.enfant,
    this.retour = false,
  });

  final String? titre;
  final Widget enfant;
  final bool retour;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: titre == null
          ? null
          : AppBar(
              title: Text(titre!),
              leading: retour ? const BackButton() : null,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: Stack(
                children: [
                  Positioned(
                    left: -110,
                    top: 10,
                    child: _blob(c.primaryContainer, 420, 430, .85),
                  ),
                  Positioned(
                    left: 140,
                    top: 220,
                    child: _blob(c.secondaryContainer, 380, 420, .80),
                  ),
                  Positioned(
                    left: -130,
                    top: 520,
                    child: _blob(c.tertiaryContainer, 390, 380, .65),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(child: enfant),
        ],
      ),
    );
  }

  Widget _blob(Color couleur, double largeur, double hauteur, double opacite) {
    return Container(
      width: largeur,
      height: hauteur,
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: opacite),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Surface de verre : remplissage translucide, bord clair, ombre douce.
/// Pas de flou d'arri├¿re-plan : ce sont les blobs qui sont floutès.
class Verre extends StatelessWidget {
  const Verre({
    super.key,
    required this.child,
    this.grand = false,
    this.rayon = 20,
  });

  final Widget child;
  final bool grand;
  final double rayon;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: grand ? .18 : .30),
        borderRadius: BorderRadius.circular(rayon),
        border: Border.all(color: c.surface.withValues(alpha: .75)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 12,
            color: c.shadow.withValues(alpha: .10),
          ),
        ],
      ),
      // Material transparent : nècessaire au ListTile pour ses effets d'ink.
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}
