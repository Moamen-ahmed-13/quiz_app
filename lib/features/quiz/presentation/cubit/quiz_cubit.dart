import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_app/features/quiz/data/models/user_answer.dart';
import 'package:quiz_app/features/quiz/data/repositories/quiz_repository.dart';
import 'package:quiz_app/features/quiz/presentation/cubit/quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _repository = GetIt.instance<QuizRepository>();
  QuizCubit() : super(const QuizState(isLoading: true)) {
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final questions = await _repository.fetchQuestions();
      emit(state.copyWith(
        questions: questions,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      print('Error loading questions from API: $e');
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
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
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));
    }else {
     emit(state.copyWith(quizCompleted: true)); 
    }
  }

  void resetQuiz() {
    emit(const QuizState(isLoading: false)); 
    loadQuestions(); 
  }
}
