
import 'package:addit/presentation/screens/edit_counter_screen.dart';
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
      builder: (context, state) => const CreateCounterScreen()
    ),
    GoRoute(
      path: '/edit-counter/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        return EditCounterScreen(id: id);
      }
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