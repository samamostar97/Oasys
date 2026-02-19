import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/example/presentation/screens/example_list_screen.dart';
import '../../features/example/presentation/screens/example_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',             builder: (_, __) => const ExampleListScreen()),
    GoRoute(path: '/examples/:id', builder: (_, s)  => ExampleDetailScreen(id: s.pathParameters['id']!)),
  ],
));
