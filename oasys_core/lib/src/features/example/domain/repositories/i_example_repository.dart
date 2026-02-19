import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/example.dart';

abstract class IExampleRepository {
  Future<Either<Failure, List<Example>>> getAll();
  Future<Either<Failure, Example>>       getById(String id);
  Future<Either<Failure, Example>>       create(String title, String description);
  Future<Either<Failure, void>>          delete(String id);
}
