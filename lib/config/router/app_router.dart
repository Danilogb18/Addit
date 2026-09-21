
import 'package:go_router/go_router.dart';
import 'package:addit/presentation/screens/screens.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/create-counter',
      builder: (context, state) => const CreateCounterScreen(),
    ),
    GoRoute(
      path: '/counter/:id',
      
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        return CounterInfoScreen(id: id);
      },
    ),
  ]
);