import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/features/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:quiz_app/features/quiz/presentation/cubit/quiz_state.dart';
import 'package:quiz_app/features/quiz/presentation/pages/results_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<QuizCubit>().loadQuestions(),
                    child: const Text('Retry',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          }
          if (state.questions.isEmpty) {
            return const Center(child: Text('No questions available.'));
          }
          final currentQuestion = state.currentQuestion!;
          final isLastQuestion =
              state.currentQuestionIndex == state.questions.length - 1;
          if (currentQuestion != null) {
            print('Correct answer: ${currentQuestion.correctAnswer}');
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value:
                      (state.currentQuestionIndex + 1) / state.questions.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 20),
                Text(
                  'Question ${state.currentQuestionIndex + 1}/${state.questions.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  currentQuestion.question,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${currentQuestion.category} - ${currentQuestion.difficulty}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      final option = currentQuestion.options[index];
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: _selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswer = value;
                          });
                        },
                        activeColor: Colors.blue,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedAnswer != null
                        ? () {
                            context
                                .read<QuizCubit>()
                                .selectAnswer(_selectedAnswer!);
                            if (isLastQuestion) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ResultsPage()),
                              );
                            } else {
                              setState(() {
                                _selectedAnswer = null;
                              });
                              context.read<QuizCubit>().nextQuestion();
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: isLastQuestion
                        ? Text('Finish Quiz',
                            style: TextStyle(color: Colors.blue))
                        : _selectedAnswer == null
                            ? Text("Next")
                            : Text(
                                "Next",
                                style: TextStyle(color: Colors.blue),
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
