import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/presentation/forgot_password_screen.dart';
import 'package:nestcare/features/auth/presentation/login_screen.dart';
import 'package:nestcare/features/auth/presentation/otp_screen.dart';
import 'package:nestcare/features/auth/presentation/registration_screen.dart';
import 'package:nestcare/features/auth/presentation/signup_screen.dart';
import 'package:nestcare/features/general/presentation/bottom_nav_screen.dart';
import 'package:nestcare/features/general/presentation/chat_screen.dart';
import 'package:nestcare/features/general/presentation/customer/clothes_screen.dart';
import 'package:nestcare/features/general/presentation/customer/make_order_screen.dart';
import 'package:nestcare/features/general/presentation/customer/order_details_screen.dart';
import 'package:nestcare/features/general/presentation/customer/schedule_drop_off_screen.dart';
import 'package:nestcare/features/general/presentation/customer/schedule_pickup_screen.dart';
import 'package:nestcare/features/general/presentation/customer/select_clothes_screen.dart';
import 'package:nestcare/features/general/presentation/customer/track_order_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_address_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_menu_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_profile_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/edit_address_screen.dart';
import 'package:nestcare/features/general/presentation/menus/invites_screen.dart';
import 'package:nestcare/features/general/presentation/menus/support_screen.dart';
import 'package:nestcare/features/general/presentation/message_screen.dart';
import 'package:nestcare/features/general/presentation/messages_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_info_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_order_details_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_profile_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_providers_screen.dart';

class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  GoRouter get router =>
      GoRouter(initialLocation: '/signup', routes: [..._authRoutes, ..._generalRoutes, ..._customerRoutes, ..._serviceProviderRoutes]);
}

// ================= AUTH ROUTES =================
final _authRoutes = <GoRoute>[
  GoRoute(
    path: '/signup',
    name: 'signup',
    builder: (context, state) => const SignupScreen(),
    routes: <GoRoute>[
      GoRoute(
        path: '/email/verify',
        name: 'verify_email',
        builder: (context, state) => OtpScreen(),
        routes: <GoRoute>[GoRoute(path: '/register', name: 'register', builder: (context, state) => const RegistrationScreen())],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        routes: <GoRoute>[GoRoute(path: '/forgot_password', name: 'forgot_password', builder: (context, state) => const ForgotPasswordScreen())],
      ),
    ],
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
        path: '/services/service_providers',
        name: 'service_providers',
        builder: (context, state) => const ServiceProvidersScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: '/service_provider_info',
            name: 'service_provider_info',
            builder: (context, state) => const ServiceProviderInfoScreen(),
            routes: <GoRoute>[
              GoRoute(
                path: '/make_order',
                name: 'make_order',
                builder: (context, state) => const MakeOrderScreen(),
                routes: <GoRoute>[
                  GoRoute(path: '/schedule_pickup', name: 'schedule_pickup', builder: (context, state) => const SchedulePickupScreen()),
                  GoRoute(path: '/schedule_drop_off', name: 'schedule_drop_off', builder: (context, state) => const ScheduleDropOffScreen()),
                  GoRoute(
                    path: '/clothes',
                    name: 'clothes',
                    builder: (context, state) => const ClothesScreen(),
                    routes: <GoRoute>[
                      GoRoute(path: '/select_clothes', name: 'select_clothes', builder: (context, state) => const SelectClothesScreen()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  GoRoute(path: '/support', name: 'support', builder: (context, state) => const SupportScreen()),
  GoRoute(
    path: '/chat/list',
    name: 'chat-list',
    builder: (context, state) => MessagesScreen(),
    routes: <GoRoute>[
      GoRoute(
        path: "/message",
        name: "message",
        builder: (context, state) => MessageScreen(providerName: 'Ayomide', providerImage: 'bana', isOnline: true),
      ),
      GoRoute(path: '/chat', name: 'chat', builder: (context, index) => ChatScreen()),
    ],
  ),
  GoRoute(path: '/invites', name: 'invites', builder: (context, state) => InvitesScreen()),
];

// ================= CUSTOMER ROUTES =================
final _customerRoutes = <GoRoute>[
  GoRoute(
    path: '/customer_menu',
    name: 'customer_menu',
    builder: (context, state) => const CustomerMenuScreen(),
    routes: <GoRoute>[
      GoRoute(path: '/profile', name: 'customer_profile', builder: (context, state) => const CustomerProfileScreen()),
      GoRoute(
        path: '/addresses',
        name: 'customer_addresses',
        builder: (context, state) => const CustomerAddressScreen(),
        routes: <GoRoute>[GoRoute(path: '/edit', name: 'edit_address', builder: (context, state) => const EditAddressScreen())],
      ),
    ],
  ),
  GoRoute(
    path: '/order/details',
    name: 'order_details',
    builder: (context, state) => const OrderDetailsScreen(),
    routes: <GoRoute>[GoRoute(path: '/track/status', name: 'track_order', builder: (context, state) => const OrderTrackingScreen())],
  ),
];

// ================= SERVICE PROVIDER ROUTES =================
final _serviceProviderRoutes = <GoRoute>[
  GoRoute(path: '/service_provider/profile', name: 'service_provider_profile', builder: (context, state) => const ServiceProviderProfileScreen()),
  GoRoute(
    path: '/service_provider/order_details',
    name: 'service_provider_order_details',
    builder: (context, state) => const ServiceProviderOrderDetailsScreen(),
  ),
];
