import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/example.dart';
import '../repositories/i_example_repository.dart';

class GetAllExamples {
  final IExampleRepository _repo;
  GetAllExamples(this._repo);
  Future<Either<Failure, List<Example>>> call() => _repo.getAll();
}
