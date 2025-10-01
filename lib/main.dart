
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/features/quiz/data/repositories/quiz_repository.dart';
import 'package:quiz_app/features/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:quiz_app/features/quiz/presentation/pages/home_page.dart';
import 'package:quiz_app/service_locator.dart';

void main() {
  setupDependencies();
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit(locator<QuizRepository>()),
      child:  MaterialApp(
          title: "Quiz App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          routes: {'/': (_) => const HomePage()},
        ),
    );
  }
}
