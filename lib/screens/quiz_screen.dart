import 'package:flutter/material.dart';

import '../models/mot.dart';
import '../models/theme_darija.dart';
import '../services/api_service.dart';

/// Question de quiz : un mot, quatre traductions possibles.
class _Question {
  const _Question({
    required this.mot,
    required this.options,
    required this.bonneReponse,
  });

  final Mot mot;
  final List<String> options;
  final String bonneReponse;
}

/// Quiz de traduction alimenté par l'API.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.theme});

  final ThemeDarija? theme;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<_Question> _questions = [];
  String? _erreur;
  int _index = 0;
  int _score = 0;
  String? _choix;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  /// Récupère les mots puis construit les questions.
  Future<void> _charger() async {
    try {
      final mots = await ApiService.getMots();
      setState(() {
        _questions = _construireQuestions(mots);
        _erreur = null;
        _index = 0;
        _score = 0;
        _choix = null;
      });
    } catch (e) {
      setState(() => _erreur = e.toString());
    }
  }

  /// Tous les mots, ou seulement ceux du thème choisi.
  List<Mot> _pool(List<Mot> mots) {
    if (widget.theme != null) {
      return mots.where((m) => m.theme == widget.theme!.nom).toList();
    }
    return mots;
  }

  List<_Question> _construireQuestions(List<Mot> mots) {
    final pool = _pool(mots);
    final selection = pool.take(5).toList();
    final questions = <_Question>[];

    for (var i = 0; i < selection.length; i++) {
      final bonne = selection[i].francais;

      final distracteurs = <String>[];
      for (var j = 1; distracteurs.length < 3 && j < pool.length; j++) {
        final candidat = pool[(i + j) % pool.length].francais;
        if (candidat != bonne && !distracteurs.contains(candidat)) {
          distracteurs.add(candidat);
        }
      }

      questions.add(
        _Question(
          mot: selection[i],
          options: [...distracteurs, bonne]..shuffle(),
          bonneReponse: bonne,
        ),
      );
    }
    return questions;
  }

  void _repondre(String option) {
    if (_choix != null) return;
    setState(() {
      _choix = option;
      if (option == _questions[_index].bonneReponse) _score++;
    });
  }

  void _suivant() {
    setState(() {
      _choix = null;
      _index++;
    });
  }

  void _recommencer() => _charger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.theme == null ? 'Quiz' : 'Quiz · ${widget.theme!.nom}',
        ),
      ),
      body: _contenu(),
    );
  }

  Widget _contenu() {
    if (_erreur != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Erreur : $_erreur', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _recommencer,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final termine = _index >= _questions.length;
    return termine ? _ecranResultat() : _ecranQuestion();
  }

  Widget _ecranQuestion() {
    final question = _questions[_index];
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${_index + 1} / ${_questions.length}',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        question.mot.darija,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.mot.arabe,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Que veut dire « ${question.mot.darija} » ?',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              for (final option in question.options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _boutonOption(option, question, c),
                ),
              if (_choix != null)
                FilledButton.icon(
                  onPressed: _suivant,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    _index + 1 < _questions.length
                        ? 'Question suivante'
                        : 'Voir le résultat',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _boutonOption(String option, _Question question, ColorScheme c) {
    final selectionne = _choix == option;
    final estBonne = option == question.bonneReponse;

    Color? fond;
    if (_choix != null && estBonne) {
      fond = c.primaryContainer;
    } else if (selectionne && !estBonne) {
      fond = c.errorContainer;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: fond),
      onPressed: () => _repondre(option),
      child: Text(option),
    );
  }

  Widget _ecranResultat() {
    final theme = Theme.of(context);
    final total = _questions.length;
    final message = _score == total
        ? 'Parfait ! Toujours barcha darija !'
        : (_score >= total / 2
              ? 'Bahi ! Continue comme ça.'
              : 'Continue à étudier, chwaya chaque jour.');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Résultat', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(
              '$_score / $total',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _recommencer,
              icon: const Icon(Icons.refresh),
              label: const Text('Recommencer'),
            ),
            if (Navigator.of(context).canPop()) ...[
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Retour'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
