import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/example.dart';
import '../../domain/repositories/i_example_repository.dart';
import '../datasources/example_remote_datasource.dart';

class ExampleRepositoryImpl implements IExampleRepository {
  final IExampleRemoteDatasource _remote;
  ExampleRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Example>>> getAll() async {
    try { return Right(await _remote.getAll()); }
    on NetworkException      { return const Left(NetworkFailure()); }
    on UnauthorizedException { return const Left(UnauthorizedFailure()); }
    on ServerException catch (e) { return Left(ServerFailure(e.message, statusCode: e.statusCode)); }
  }

  @override
  Future<Either<Failure, Example>> getById(String id) async {
    try { return Right(await _remote.getById(id)); }
    on NotFoundException catch (e) { return Left(NotFoundFailure(e.message)); }
    on ServerException   catch (e) { return Left(ServerFailure(e.message)); }
  }

  @override
  Future<Either<Failure, Example>> create(String title, String description) async {
    try { return Right(await _remote.create(title, description)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try { await _remote.delete(id); return const Right(null); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
  }
}
