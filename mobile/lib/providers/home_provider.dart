import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/routes/app_router.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/user_provider.dart';

final bottomNavigationProvider = StateProvider<int>((ref) => 0);

final routerProvider = Provider<GoRouter>((ref) => AppRouter(ref).router);

final clearAllProviders = Provider((ref) {
  return () {
    ref.read(loadingProvider.notifier).state = false;
    ref.read(userProvider.notifier).clearUser();
  };
});
