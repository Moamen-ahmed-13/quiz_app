import 'dart:math';

import 'package:html_unescape/html_unescape.dart';

class Question {
  final int id;
  final String category;
  final String difficulty;
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
 factory Question.fromApiJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    final correct = unescape.convert(json['correct_answer'] as String);
    final incorrect = (json['incorrect_answers'] as List).map((e) => unescape.convert(e as String)).toList();

    final options = List<String>.from(incorrect)..add(correct)..shuffle();

    return Question(
      id: DateTime.now().millisecondsSinceEpoch + Random().nextInt(1000),
      category: unescape.convert(json['category'] as String),
      difficulty: unescape.convert(json['difficulty'] as String),
      question: unescape.convert(json['question'] as String),
      options: options,
      correctAnswer: correct,
    );
  }
}
