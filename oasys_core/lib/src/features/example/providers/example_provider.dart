import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/example.dart';
import '../domain/usecases/get_all_examples.dart';

sealed class ExampleState {}
class ExampleInitial extends ExampleState {}
class ExampleLoading extends ExampleState {}
class ExampleLoaded  extends ExampleState { final List<Example> items; ExampleLoaded(this.items); }
class ExampleError   extends ExampleState { final String message; ExampleError(this.message); }

class ExampleNotifier extends StateNotifier<ExampleState> {
  final GetAllExamples _getAll;
  ExampleNotifier(this._getAll) : super(ExampleInitial());

  Future<void> load() async {
    state = ExampleLoading();
    final result = await _getAll();
    result.fold(
      (f) => state = ExampleError(f.message),
      (items) => state = ExampleLoaded(items),
    );
  }
}
