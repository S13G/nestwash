import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/signup_screen.dart';
import 'package:nestcare/features/general/presentation/home_screen.dart';

class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  GoRouter get router => GoRouter(
    initialLocation: '/signup',
    routes: [
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
