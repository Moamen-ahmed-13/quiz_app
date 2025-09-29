import 'package:get_it/get_it.dart';
import 'package:quiz_app/features/quiz/data/repositories/quiz_repository.dart';

final GetIt locator = GetIt.instance;

void setupDependencies() {
  locator.registerLazySingleton<QuizRepository>(()=> QuizRepository());
}