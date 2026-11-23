import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/validation_form.dart';

/// Formulaire « Ajouter un mot » : validation puis envoi à l'API.
class AjouterMotScreen extends StatefulWidget {
  const AjouterMotScreen({super.key});

  @override
  State<AjouterMotScreen> createState() => _AjouterMotScreenState();
}

class _AjouterMotScreenState extends State<AjouterMotScreen> {
  final _cle = GlobalKey<FormState>();
  final _darija = TextEditingController();
  final _arabe = TextEditingController();
  final _francais = TextEditingController();
  final _exemple = TextEditingController();
  final _exempleFr = TextEditingController();
  String _niveau = 'Débutant';
  bool _envoiEnCours = false;

  @override
  void dispose() {
    _darija.dispose();
    _arabe.dispose();
    _francais.dispose();
    _exemple.dispose();
    _exempleFr.dispose();
    super.dispose();
  }

  Future<void> _envoyer() async {
    if (!_cle.currentState!.validate()) return;

    setState(() => _envoiEnCours = true);
    try {
      await ApiService.ajouterMot(
        darija: _darija.text.trim(),
        arabe: _arabe.text.trim(),
        francais: _francais.text.trim(),
        niveau: _niveau,
        exemple: _exemple.text.trim(),
        exemplefr: _exempleFr.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Mot enregistré ✅')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _envoiEnCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un mot')),
      body: Form(
        key: _cle,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _darija,
              validator: (v) => champObligatoire(v, 'Le mot en darija'),
              decoration: const InputDecoration(
                labelText: 'Mot en darija',
                hintText: 'Ex. : Sa7bi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _arabe,
              decoration: const InputDecoration(
                labelText: 'Écriture arabe (facultatif)',
                hintText: 'Ex. : صاحبي',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _francais,
              validator: (v) => champObligatoire(v, 'La traduction'),
              decoration: const InputDecoration(
                labelText: 'Traduction en français',
                hintText: 'Ex. : Mon ami',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _niveau,
              validator: (v) =>
                  (v == null || !niveauValide(v)) ? 'Niveau invalide' : null,
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
            TextFormField(
              controller: _exemple,
              decoration: const InputDecoration(
                labelText: 'Exemple en darija (facultatif)',
                hintText: 'Ex. : Sa7bi, chnahwelek?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _exempleFr,
              validator: (v) =>
                  _exemple.text.trim().isNotEmpty &&
                      (v == null || v.trim().isEmpty)
                  ? 'Traduisez aussi votre exemple'
                  : null,
              decoration: const InputDecoration(
                labelText: 'Exemple traduit',
                hintText: 'Ex. : Mon ami, comment ça va ?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _envoiEnCours ? null : _envoyer,
              icon: _envoiEnCours
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add),
              label: Text(_envoiEnCours ? 'Envoi...' : 'Ajouter le mot'),
            ),
          ],
        ),
      ),
    );
  }
}
