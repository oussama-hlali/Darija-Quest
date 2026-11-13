import 'package:flutter/material.dart';

import '../data/donnees_fictives.dart';
import '../models/mot.dart';
import '../models/theme_darija.dart';

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

/// Quiz de traduction (jalon J1).
///
/// - Ouvert depuis la barre inférieure : les mots de tous les thèmes
///   sont utilisés.
/// - Ouvert depuis le détail d'un thème : seuls les mots du thème
///   (`QuizScreen(theme: t)`).
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.theme});

  final ThemeDarija? theme;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<_Question> _questions;
  int _index = 0;
  int _score = 0;
  String? _choix;

  @override
  void initState() {
    super.initState();
    _questions = _construireQuestions();
  }

  /// Mots disponibles pour ce quiz.
  List<Mot> _pool() {
    if (widget.theme != null) return widget.theme!.mots;

    // Sans thème précis : alterner un mot de chaque thème.
    final pool = <Mot>[];
    var longueurMax = 0;
    for (final t in themes) {
      if (t.mots.length > longueurMax) longueurMax = t.mots.length;
    }
    for (var i = 0; i < longueurMax; i++) {
      for (final t in themes) {
        if (i < t.mots.length) pool.add(t.mots[i]);
      }
    }
    return pool;
  }

  List<_Question> _construireQuestions() {
    final pool = _pool();
    final selection = pool.take(5).toList();
    final questions = <_Question>[];

    for (var i = 0; i < selection.length; i++) {
      final bonne = selection[i].francais;

      // Trois distracteurs pris dans le reste du pool.
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
    if (_choix != null) return; // une réponse par question
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

  void _recommencer() {
    setState(() {
      _questions = _construireQuestions();
      _index = 0;
      _score = 0;
      _choix = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final termine = _index >= _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.theme == null ? 'Quiz' : 'Quiz · ${widget.theme!.nom}',
        ),
      ),
      body: termine ? _ecranResultat() : _ecranQuestion(),
    );
  }

  Widget _ecranQuestion() {
    final question = _questions[_index];
    final theme = Theme.of(context);

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
                  child: _boutonOption(option, question),
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

  Widget _boutonOption(String option, _Question question) {
    final selectionne = _choix == option;
    final estBonne = option == question.bonneReponse;

    Color? fond;
    if (_choix != null && estBonne) {
      fond = Colors.green.shade100; // la bonne réponse apparaît en vert
    } else if (selectionne && !estBonne) {
      fond = Colors.red.shade100; // l'erreur de l'utilisateur en rouge
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
