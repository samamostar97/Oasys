import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/example/presentation/screens/example_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (_, __) => const ExampleScreen())],
));
