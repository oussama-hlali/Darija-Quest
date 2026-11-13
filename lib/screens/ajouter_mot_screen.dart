import 'package:flutter/material.dart';

/// Formulaire « Ajouter un mot » (jalon J1 : champs affichés).
///
/// Aucune validation ni enregistrement ici (exigences du jalon J1) :
/// le bouton affiche seulement un message de démo. La validation
/// (EF3) et la sauvegarde viendront d'un jalon suivant.
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
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un mot')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _darija,
            decoration: const InputDecoration(
              labelText: 'Mot en darija',
              hintText: 'Ex. : Sa7bi',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _arabe,
            decoration: const InputDecoration(
              labelText: 'Écriture arabe',
              hintText: 'Ex. : صاحبي',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _francais,
            decoration: const InputDecoration(
              labelText: 'Traduction en français',
              hintText: 'Ex. : Mon ami',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _niveau,
            decoration: const InputDecoration(
              labelText: 'Niveau',
              border: OutlineInputBorder(),
            ),
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
          const SizedBox(height: 12),
          TextField(
            controller: _exemple,
            decoration: const InputDecoration(
              labelText: 'Exemple en darija',
              hintText: 'Ex. : Sa7bi, chnahwelek?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _exempleFr,
            decoration: const InputDecoration(
              labelText: 'Exemple traduit',
              hintText: 'Ex. : Mon ami, comment ça va ?',
              border: OutlineInputBorder(),
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
