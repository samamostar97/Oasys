import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/example.dart';
import '../repositories/i_example_repository.dart';

class CreateExample {
  final IExampleRepository _repo;
  CreateExample(this._repo);
  Future<Either<Failure, Example>> call(String title, String description) =>
      _repo.create(title, description);
}
