import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/presentation/signup_screen.dart';
import 'package:nestcare/features/general/presentation/bottom_nav_screen.dart';
import 'package:nestcare/features/general/presentation/menus/chat_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_address_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_menu_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_profile_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/edit_address_screen.dart';
import 'package:nestcare/features/general/presentation/menus/invites_screen.dart';
import 'package:nestcare/features/general/presentation/menus/support_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_providers_screen.dart';

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
    routes: <GoRoute>[
      GoRoute(
        path: '/bottom_nav/services/service_providers',
        name: 'service_providers',
        builder: (context, state) => const ServiceProvidersScreen(),
      ),
    ],
  ),
  GoRoute(
    path: '/support',
    name: 'support',
    builder: (context, state) => const SupportScreen(),
  ),
  GoRoute(
    path: '/chat',
    name: 'chat',
    builder: (context, state) => ChatScreen(),
  ),
  GoRoute(
    path: '/invites',
    name: 'invites',
    builder: (context, state) => InvitesScreen(),
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
        path: '/customer_menu/profile',
        name: 'customer_profile',
        builder: (context, state) => const CustomerProfileScreen(),
      ),
      GoRoute(
        path: '/customer_menu/addresses',
        name: 'customer_addresses',
        builder: (context, state) => const CustomerAddressScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: '/customer_menu/addresses/edit',
            name: 'edit_address',
            builder: (context, state) => const EditAddressScreen(),
          ),
        ],
      ),
    ],
  ),
];
