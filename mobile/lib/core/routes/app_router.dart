import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/presentation/forgot_password_screen.dart';
import 'package:nestcare/features/auth/presentation/login_screen.dart';
import 'package:nestcare/features/auth/presentation/otp_screen.dart';
import 'package:nestcare/features/auth/presentation/registration_screen.dart';
import 'package:nestcare/features/auth/presentation/signup_screen.dart';
import 'package:nestcare/features/general/presentation/bottom_nav_screen.dart';
import 'package:nestcare/features/general/presentation/customer/clothes_screen.dart';
import 'package:nestcare/features/general/presentation/customer/make_order_screen.dart';
import 'package:nestcare/features/general/presentation/customer/order_details_screen.dart';
import 'package:nestcare/features/general/presentation/customer/schedule_drop_off_screen.dart';
import 'package:nestcare/features/general/presentation/customer/schedule_pickup_screen.dart';
import 'package:nestcare/features/general/presentation/customer/select_clothes_screen.dart';
import 'package:nestcare/features/general/presentation/customer/track_order_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_menu_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_orders_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/customer_profile_screen.dart';
import 'package:nestcare/features/general/presentation/menus/customer/delivery_address_screen.dart';
import 'package:nestcare/features/general/presentation/menus/invites_screen.dart';
import 'package:nestcare/features/general/presentation/menus/support_screen.dart';
import 'package:nestcare/features/general/presentation/menus/terms_screen.dart';
import 'package:nestcare/features/general/presentation/menus/transaction_history_screen.dart';
import 'package:nestcare/features/general/presentation/message_screen.dart';
import 'package:nestcare/features/general/presentation/messages_screen.dart';
import 'package:nestcare/features/general/services/model/service_provider_model.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_info_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_order_details_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_profile_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_reviews_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_providers_screen.dart';

class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  GoRouter get router => GoRouter(
    initialLocation: '/signup',
    routes: [
      ..._authRoutes,
      ..._generalRoutes,
      ..._customerRoutes,
      ..._serviceProviderRoutes,
    ],
  );
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
        routes: <GoRoute>[
          GoRoute(
            path: '/register',
            name: 'register',
            builder: (context, state) => const RegistrationScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: '/forgot_password',
            name: 'forgot_password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
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
        builder: (context, state) {
          final selectedService =
              state.uri.queryParameters['selectedService'] ?? '';
          return ServiceProvidersScreen(selectedService: selectedService);
        },
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
                  GoRoute(
                    path: '/schedule_pickup',
                    name: 'schedule_pickup',
                    builder: (context, state) => const SchedulePickupScreen(),
                  ),
                  GoRoute(
                    path: '/schedule_drop_off',
                    name: 'schedule_drop_off',
                    builder: (context, state) => const ScheduleDropOffScreen(),
                  ),
                  GoRoute(
                    path: '/clothes',
                    name: 'clothes',
                    builder: (context, state) => const ClothesScreen(),
                    routes: <GoRoute>[
                      GoRoute(
                        path: '/select_clothes',
                        name: 'select_clothes',
                        builder:
                            (context, state) => const SelectClothesScreen(),
                      ),
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
  GoRoute(
    path: '/terms',
    name: 'terms',
    builder: (context, state) => const TermsScreen(),
  ),
  GoRoute(
    path: '/support',
    name: 'support',
    builder: (context, state) => const SupportScreen(),
  ),
  GoRoute(
    path: '/chat/list',
    name: 'chat-list',
    builder: (context, state) => MessagesScreen(),
    routes: <GoRoute>[
      GoRoute(
        path: "/chat",
        name: "chat",
        builder: (context, state) => MessageScreen(),
      ),
    ],
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
        path: '/profile',
        name: 'customer_profile',
        builder: (context, state) => const CustomerProfileScreen(),
      ),
      GoRoute(
        path: '/orders',
        name: 'customer_orders',
        builder: (context, state) => const CustomerOrdersScreen(),
      ),
      GoRoute(
        path: '/addresses',
        name: 'customer_addresses',
        builder: (context, state) => const DeliveryAddressesScreen(),
      ),
    ],
  ),
  GoRoute(
    path: '/order/details',
    name: 'order_details',
    builder: (context, state) => OrderDetailsScreen(),
    routes: <GoRoute>[
      GoRoute(
        path: '/track/status',
        name: 'track_order',
        builder: (context, state) => const TrackOrderScreen(),
      ),
    ],
  ),
  GoRoute(
    path: '/transaction/history',
    name: 'transaction_history',
    builder: (context, state) => const TransactionHistoryScreen(),
  ),
];

// ================= SERVICE PROVIDER ROUTES =================
final _serviceProviderRoutes = <GoRoute>[
  GoRoute(
    path: '/service_provider/profile',
    name: 'service_provider_profile',
    builder: (context, state) {
      final provider = state.extra as ServiceProvider;
      return ServiceProviderProfileScreen(provider: provider);
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/reviews',
        name: 'service_provider_reviews',
        builder: (context, state) {
          final provider = state.extra as ServiceProvider;
          return ServiceProviderReviewsScreen(provider: provider);
        },
      ),
    ],
  ),
  GoRoute(
    path: '/service_provider/order_details',
    name: 'service_provider_order_details',
    builder: (context, state) => const ServiceProviderOrderDetailsScreen(),
  ),
];
