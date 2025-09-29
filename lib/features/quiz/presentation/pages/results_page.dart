import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/features/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:quiz_app/features/quiz/presentation/cubit/quiz_state.dart';
import 'package:quiz_app/features/quiz/presentation/pages/home_page.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Results'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<QuizCubit, QuizState>(builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }
          if (state.userAnswers.isEmpty) {
            return const Center(
                child: Text(
              'No answers found.',
              style: TextStyle(color: Colors.blue),
            ));
          }
          final totalQuestions = state.questions.length;
          final score = state.score;
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'You scored $score out of $totalQuestions!',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${((score / totalQuestions) * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: score >= 7 ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Question Review:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.questions.length,
                        itemBuilder: (context, index) {
                          final question = state.questions[index];
                          final userAnswer =
                              state.getSelectedAnswerForQuestion(question.id);
                          final isCorrect = userAnswer == question.correctAnswer;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            color: isCorrect ? Colors.green[50] : Colors.red[50],
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Q${index + 1}: ${question.question}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  if (userAnswer != null) ...[
                                    Text(
                                      'Your Answer: $userAnswer',
                                      style: TextStyle(
                                        color: isCorrect? Colors.green[700] : Colors.red[700],
                                        fontWeight: FontWeight.w500,
                                      ),

                                      ),
                                    const SizedBox(height: 5),
                                    ],
                                    Text(
                                      'Correct Answer: ${question.correctAnswer}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        ),
                        const SizedBox(height: 20),
                        // Retake Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<QuizCubit>().resetQuiz();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[50],
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Retake Quiz', style: TextStyle(color: Colors.blue)),
                      
                          ),
                          ),
                          const SizedBox(height: 20),
                          
                      
                                  
                  ],),);
        }));
  }
}
