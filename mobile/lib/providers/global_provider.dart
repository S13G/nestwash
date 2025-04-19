import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/routes/app_router.dart';

final routerProvider = Provider<GoRouter>((ref) => AppRouter(ref).router);

final emailProvider = StateProvider<String>((ref) => '');
final fullNameProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
final otpProvider = StateProvider<String>((ref) => '');

final loadingProvider = StateProvider<bool>((ref) => false);

final pageIndexProvider = StateProvider<int>((ref) => 0);

final passwordVisibilityProvider = StateProvider<bool>((ref) => false);
