import 'package:equatable/equatable.dart';
import 'package:quiz_app/features/quiz/data/models/questions_model.dart';
import 'package:quiz_app/features/quiz/data/models/user_answer.dart';

class QuizState extends Equatable {
  final List<Question> questions;
  final List<UserAnswer> userAnswers;
  final int currentQuestionIndex;
  final int score;
  final bool quizCompleted;
  final bool isLoading;
  final String? error;

  const QuizState({
    this.questions = const [],
    this.userAnswers = const [],
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.quizCompleted = false,
    this.isLoading = false,
    this.error,
  });

  QuizState copyWith({
    List<Question>? questions,
    List<UserAnswer>? userAnswers,
    int? currentQuestionIndex,
    int? score,
    bool? quizCompleted,
    bool? isLoading,
    String? error,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      quizCompleted: quizCompleted ?? this.quizCompleted,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        userAnswers,
        currentQuestionIndex,
        score,
        quizCompleted,
        isLoading,
        error,
      ];

  Question? get currentQuestion =>
      currentQuestionIndex < questions.length ? questions[currentQuestionIndex] : null;

      String? getSelectedAnswerForQuestion(int questionId) {
        try {
          final answer = userAnswers.firstWhere((ua) => ua.questionId == questionId);
          return answer.selectedAnswer.isNotEmpty ? answer.selectedAnswer : null;
        } catch (e) {
          return null;
        }
      }
      
}
