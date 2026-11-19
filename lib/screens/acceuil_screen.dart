import 'package:material_ui/material_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final query = _recherche.text.trim().toLowerCase();
    final themesVisibles = themes
        .where((t) => t.nom.toLowerCase().contains(query))
        .toList();

    return PageVerre(
      enfant: ListView(
        padding: const EdgeInsets.fromLTRB(16, 44, 16, 110),
        children: [
          Verre(
            child: Row(
              children: [
                Icon(Icons.local_fire_department, color: c.primary),
                const SizedBox(width: 8),
                Text('Sèrie : 3 jours', style: TextStyle(color: c.onSurface)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Darija Quest',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: c.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Apprends la darija tunisienne',
            style: TextStyle(color: c.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _recherche,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Rechercher un thème',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: c.onSurface.withValues(alpha: .06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Tous')),
              Chip(label: Text('Dèbutant')),
              Chip(label: Text('Intermèdiaire')),
            ],
          ),
          const SizedBox(height: 12),
          Verre(
            grand: true,
            rayon: 28,
            child: Column(
              children: [
                for (final t in themesVisibles) _ligneTheme(context, t),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ligneTheme(BuildContext context, ThemeDarija t) {
    final c = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ThemeDetailScreen(theme: t)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: c.surface.withValues(alpha: .66),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.primary, width: 4),
              ),
              child: Icon(t.icone, size: 16, color: c.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.nom,
                    style: TextStyle(
                      color: c.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${t.mots.length} mots',
                    style: TextStyle(color: c.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: c.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
