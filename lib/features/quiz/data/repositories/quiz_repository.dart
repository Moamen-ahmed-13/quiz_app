import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:quiz_app/features/quiz/data/models/failure.dart';
import 'package:quiz_app/features/quiz/data/models/questions_model.dart';
import 'package:http/http.dart' as http;

class QuizRepository {
  static const String _baseUrl = 'https://opentdb.com/api.php';

  Future<Either<Failure,List<Question>>> fetchQuestions({int amount = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?amount=$amount&category=18&type=multiple'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['response_code'] == 0) {
          final List<dynamic> results = jsonData['results'];
          final questions = results.map((json) => Question.fromApiJson(json)).toList();
          return Right(questions);
          
        }else{
          return Left(Failure("Api error: ${jsonData['response_code']}: ${jsonData['response_message']}"));
        }
      }else{
        return Left(Failure("Failed to load questions from API: ${response.statusCode}"));}
    }on TimeoutException {
      return Left(Failure('Request timed out. Please try again.'));
    }
     catch (e) {
      return Left(Failure('Network error: $e'));
    }
  }
}
