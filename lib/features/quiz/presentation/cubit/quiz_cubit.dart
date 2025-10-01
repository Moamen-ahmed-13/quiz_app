import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:quiz_app/features/quiz/data/models/failure.dart';
import 'package:quiz_app/features/quiz/data/models/questions_model.dart';
import 'package:quiz_app/features/quiz/data/models/user_answer.dart';
import 'package:quiz_app/features/quiz/data/repositories/quiz_repository.dart';
import 'package:quiz_app/features/quiz/presentation/cubit/quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _repository;
  final Logger _logger = Logger();
  QuizCubit(this._repository)
      : super(const QuizState(status: RequestStatus.init)) {
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    emit(state.copyWith(status: RequestStatus.loading, error: null));
    final Either<Failure, List<Question>> result =
        await _repository.fetchQuestions();
    result.fold((failure) {
      _logger.e("Error loading questions: ${failure.message}");
      emit(state.copyWith(status: RequestStatus.error, error: failure.message));
    }, (questions) {
      emit(state.copyWith(questions: questions, status: RequestStatus.loaded,
          currentQuestionIndex: 0, score: 0, userAnswers: [], quizCompleted: false, error: null));
    });
  }

  void selectAnswer(String answer) {
    if (state.currentQuestionIndex < state.questions.length) {
      final question = state.questions[state.currentQuestionIndex];
      final isCorrect = answer == question.correctAnswer;
      final newScore = isCorrect ? state.score + 1 : state.score;

      final newUserAnswers = List<UserAnswer>.from(state.userAnswers);
      newUserAnswers.add(UserAnswer(
        questionId: question.id,
        selectedAnswer: answer,
        isCorrect: isCorrect,
      ));
      emit(state.copyWith(
        userAnswers: newUserAnswers,
        score: newScore,
      ));
    }
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      emit(
          state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
    } else {
      emit(state.copyWith(quizCompleted: true));
    }
  }

  void resetQuiz() {
    emit(const QuizState(status: RequestStatus.init));
    loadQuestions();
  }
}
