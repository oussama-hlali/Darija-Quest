import 'package:material_ui/material_ui.dart';

import '../widgets/verre.dart';

/// Formulaire « Ajouter un mot » (jalon J1 : champs affichés).
/// Aucune validation ni enregistrement : le bouton affiche un message de démo.
class AjouterMotScreen extends StatefulWidget {
  const AjouterMotScreen({super.key});

  @override
  State<AjouterMotScreen> createState() => _AjouterMotScreenState();
}

class _AjouterMotScreenState extends State<AjouterMotScreen> {
  final _darija = TextEditingController();
  final _arabe = TextEditingController();
  final _francais = TextEditingController();
  final _exemple = TextEditingController();
  final _exempleFr = TextEditingController();
  String _niveau = 'Débutant';

  @override
  void dispose() {
    _darija.dispose();
    _arabe.dispose();
    _francais.dispose();
    _exemple.dispose();
    _exempleFr.dispose();
    super.dispose();
  }

  void _envoyer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Jalon J1 : démo du formulaire — l'enregistrement viendra plus tard.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageVerre(
      titre: 'Ajouter un mot',
      retour: true,
      enfant: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Verre(
            child: TextField(
              controller: _darija,
              decoration: const InputDecoration(
                labelText: 'Mot en darija',
                hintText: 'Ex. : Sa7bi',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Verre(
            child: TextField(
              controller: _arabe,
              decoration: const InputDecoration(
                labelText: 'Écriture arabe',
                hintText: 'Ex. : صاحبي',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Verre(
            child: TextField(
              controller: _francais,
              decoration: const InputDecoration(
                labelText: 'Traduction en français',
                hintText: 'Ex. : Mon ami',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Verre(
            child: DropdownButtonFormField<String>(
              initialValue: _niveau,
              decoration: const InputDecoration(labelText: 'Niveau'),
              items: const [
                DropdownMenuItem(value: 'Débutant', child: Text('Débutant')),
                DropdownMenuItem(
                  value: 'Intermédiaire',
                  child: Text('Intermédiaire'),
                ),
                DropdownMenuItem(value: 'Avancé', child: Text('Avancé')),
              ],
              onChanged: (valeur) => setState(() => _niveau = valeur!),
            ),
          ),
          const SizedBox(height: 12),
          Verre(
            child: TextField(
              controller: _exemple,
              decoration: const InputDecoration(
                labelText: 'Exemple en darija',
                hintText: 'Ex. : Sa7bi, chnahwelek?',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Verre(
            child: TextField(
              controller: _exempleFr,
              decoration: const InputDecoration(
                labelText: 'Exemple traduit',
                hintText: 'Ex. : Mon ami, comment ça va ?',
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _envoyer,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter le mot'),
          ),
        ],
      ),
    );
  }
}
