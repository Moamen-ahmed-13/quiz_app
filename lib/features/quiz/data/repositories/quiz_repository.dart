import 'dart:convert';

import 'package:quiz_app/features/quiz/data/models/questions_model.dart';
import 'package:http/http.dart' as http;

class QuizRepository {
  static const String _baseUrl = 'https://opentdb.com/api.php';

  Future<List<Question>> fetchQuestions({int amount = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?amount=$amount&category=18&type=multiple'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['response_code'] == 0) {
          final List<dynamic> results = jsonData['results'];
          return results.map((json) => Question.fromApiJson(json)).toList();
          
        }else{
          throw Exception('API error: ${jsonData['response_code']}');
        }
      }else{
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load questions from API: $e');
    }
  }
}
