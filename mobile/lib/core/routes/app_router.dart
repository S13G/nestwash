import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/presentation/signup_screen.dart';
import 'package:nestcare/features/general/presentation/bottom_nav_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_address_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_menu_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_profile_screen.dart';
import 'package:nestcare/features/general/presentation/menus/support_screen.dart';

class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  GoRouter get router => GoRouter(
    initialLocation: '/signup',
    routes: [..._authRoutes, ..._generalRoutes, ..._customerRoutes],
  );
}

// ================= AUTH ROUTES =================
final _authRoutes = <GoRoute>[
  GoRoute(
    path: '/signup',
    name: 'signup',
    builder: (context, state) => const SignupScreen(),
  ),
];

// ================= GENERAL ROUTES =================
final _generalRoutes = <GoRoute>[
  GoRoute(
    path: '/bottom_nav',
    name: 'bottom_nav',
    builder: (context, state) => const BottomNavScreen(),
  ),
  GoRoute(
    path: '/support',
    name: 'support',
    builder: (context, state) => const SupportScreen(),
  ),
];

// ================= CUSTOMER ROUTES =================
final _customerRoutes = <GoRoute>[
  GoRoute(
    path: '/customer_menu',
    name: 'customer_menu',
    builder: (context, state) => const CustomerMenuScreen(),
    routes: <GoRoute>[
      GoRoute(
        path: '/customer/profile',
        name: 'customer_profile',
        builder: (context, state) => const CustomerProfileScreen(),
      ),
      GoRoute(
        path: '/customer/addresses',
        name: 'customer_addresses',
        builder: (context, state) => const CustomerAddressScreen(),
      ),
    ],
  ),
];
