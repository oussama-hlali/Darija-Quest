import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favoris_provider.dart';

class BoutonFavori extends StatelessWidget {
  const BoutonFavori({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final favoris = context.watch<FavorisProvider>();
    final c = Theme.of(context).colorScheme;
    final actif = favoris.estFavori(id);

    return IconButton(
      onPressed: () => favoris.basculer(id),
      tooltip: 'Favori',
      icon: Icon(
        actif ? Icons.favorite : Icons.favorite_border,
        color: actif ? c.primary : c.onSurfaceVariant,
      ),
    );
  }
}
