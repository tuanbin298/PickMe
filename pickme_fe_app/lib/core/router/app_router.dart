import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/auth/screens/forgot_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/otp_verification_page.dart';
import 'package:pickme_fe_app/features/auth/screens/reset_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/login_page.dart';
import 'package:pickme_fe_app/features/auth/screens/register_page.dart';
import 'package:pickme_fe_app/features/customer/screens/home/home_page.dart';
import 'package:pickme_fe_app/features/customer/screens/map/map_page.dart';
import 'package:pickme_fe_app/features/customer/screens/order/order_confirm_page.dart';
import 'package:pickme_fe_app/features/customer/screens/order/order_detail_page.dart';
import 'package:pickme_fe_app/core/common_widgets/profile/account_info_page.dart';
import 'package:pickme_fe_app/core/common_widgets/profile/addresses_page.dart';
import 'package:pickme_fe_app/core/common_widgets/profile/change_password_page.dart';
import 'package:pickme_fe_app/core/common_widgets/profile/payment_methods_page.dart';
import 'package:pickme_fe_app/features/customer/screens/profile/profile_page.dart';
import 'package:pickme_fe_app/features/customer/screens/customer_bottom_nav.dart';
import 'package:pickme_fe_app/features/customer/screens/qr_code/payment_qr_page.dart';
import 'package:pickme_fe_app/features/customer/screens/restaurant/restaurant_menu_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/home/merchant_home_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/merchant_navigate_bottom.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/merchant_restaurant/create_restaurant_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/merchant_restaurant/merchant_restaurant_list.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/profile/merchant_profile.dart';
import 'package:pickme_fe_app/features/merchant/screens/restaurant/menu/create_menu_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/restaurant/restaurant_detail/restaurant_detail_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/restaurant/restaurant_feedback/restaurant_feedback_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/restaurant/restaurant_navigate_bottom.dart';
import 'package:pickme_fe_app/features/merchant/screens/restaurant/restaurant_order/restaurant_order.dart';
import 'package:pickme_fe_app/features/customer/screens/restaurant/restaurant_menu_detail_page.dart';
import 'package:pickme_fe_app/features/customer/screens/cart/cart_overview_page.dart';
import 'package:pickme_fe_app/features/customer/screens/order/order_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/restaurant/restaurant_order/restaurant_order_detail.dart';
import 'package:pickme_fe_app/features/not_found/not_found_page.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/screens/cart/cart_confirm_page.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';

// Router configuration for the application
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _restaurantNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    debugLogDiagnostics: true, //console router
    routes: [
      // ================= AUTH =================
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: "/register",
        name: "register",
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: "/forgot-password",
        name: "forgot-password",
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: "/otp",
        name: "otp",
        builder: (context, state) {
          // get email from ForgotPasswordPage
          final email = state.extra as String;
          return OtpVerificationPage(email: email);
        },
      ),

      GoRoute(
        path: "/reset-password",
        name: "reset-password",
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final email = data["email"] as String;
          final otp = data["otp"] as String;
          return ResetPasswordPage(email: email, otp: otp);
        },
      ),

      // ================= CUSTOMER =================
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        builder: (context, state, child) {
          // Take token from state.extra
          final token = state.extra is String ? state.extra as String : null;

          // Push token into MerchantNavigateBottom
          return CustomerBottomNav(token: token, child: child);
        },
        routes: [
          GoRoute(
            path: "/home-page",
            name: "home-page",
            builder: (context, state) {
              final shellWidget = context
                  .findAncestorWidgetOfExactType<CustomerBottomNav>();
              final token = shellWidget?.token ?? "";

              return Homepage(token: token);
            },
          ),

          GoRoute(
            path: '/orders',
            builder: (context, state) {
              final shellWidget = context
                  .findAncestorWidgetOfExactType<CustomerBottomNav>();
              final token = shellWidget?.token ?? "";

              return OrdersPage(token: token);
            },
          ),

          GoRoute(
            path: "/profile",
            name: "profile",
            builder: (context, state) {
              final shellWidget = context
                  .findAncestorWidgetOfExactType<CustomerBottomNav>();
              final token = shellWidget?.token ?? "";

              return ProfilePage(token: token);
            },
          ),
        ],
      ),

      GoRoute(
        path: '/orders/:id',
        name: "orders-detail",
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>;
          final orderId = extraData['orderId'] as int;
          final token = extraData['token'] as String;

          return OrderDetailPage(orderId: orderId, token: token);
        },
      ),

      GoRoute(
        path: '/restaurant/:id',
        name: "restaurant-menu",
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>;
          final restaurant = extraData['restaurant'] as Restaurant;
          final token = extraData['token'] as String? ?? '';
          return RestaurantMenuPage(restaurant: restaurant, token: token);
        },
      ),

      GoRoute(
        path: '/restaurant/:id/menu-detail/:menuId',
        name: 'restaurant-menu-detail',
        builder: (context, state) {
          final restaurantId =
              int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final menuItemId =
              int.tryParse(state.pathParameters['menuId'] ?? '') ?? 0;

          final extra = state.extra as Map<String, dynamic>? ?? {};
          final token = extra['token'] as String? ?? '';

          return RestaurantMenuDetailPage(
            token: token,
            restaurantId: restaurantId,
            menuItemId: menuItemId,
          );
        },
      ),

      GoRoute(
        path: "/cart",
        name: "cart",
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>;

          return CartConfirmPage(
            token: extraData["token"] as String,
            restaurant: extraData["restaurant"] as Restaurant,
            cartItems: extraData["cartItems"] as List<CartItem>,
            cartId: extraData["cartId"] as int,
            total: (extraData["total"] as num).toDouble(),
          );
        },
      ),

      GoRoute(
        path: "/cart-overview",
        name: "cart-overview",
        builder: (context, state) {
          final token = state.extra as String? ?? '';
          return CartOverviewPage(token: token);
        },
      ),

      GoRoute(
        path: "/order-confirm",
        name: "order-confirm",
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>;

          return OrderConfirmPage(
            token: extraData["token"] as String,
            id: extraData["id"] as int,
          );
        },
      ),

      GoRoute(
        path: "/payment-qr",
        name: "payment-qr",
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>;

          return PaymentQrPage(qrCodeUrl: extraData["qrCodeUrl"] as String);
        },
      ),

      GoRoute(
        path: "/account-information",
        name: "account-information",
        builder: (context, state) {
          final token = state.extra as String? ?? "";
          return AccountInfoPage(token: token);
        },
      ),

      GoRoute(
        path: "/account-resetpassword",
        name: "account-resetpassword",
        builder: (context, state) {
          final token = state.extra as String? ?? "";
          return ChangePasswordPage(token: token);
        },
      ),

      GoRoute(
        path: "/account-payment-method",
        name: "account-payment-method",
        builder: (context, state) {
          final token = state.extra as String? ?? "";
          return PaymentMethodsPage(token: token);
        },
      ),

      GoRoute(
        path: "/account-address",
        name: "account-address",
        builder: (context, state) {
          final token = state.extra as String? ?? "";
          return AddressesPage(token: token);
        },
      ),

      GoRoute(
        path: "/map",
        name: "map",
        builder: (context, state) {
          return MapPage();
        },
      ),

      // ================= MERCHANT =================
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        builder: (context, state, child) {
          // Take token from state.extra
          final token = state.extra is String ? state.extra as String : null;

          // Push token into MerchantNavigateBottom
          return MerchantNavigateBottom(token: token, child: child);
        },
        routes: [
          GoRoute(
            path: "/merchant-homepage",
            name: "merchant-homepage",
            builder: (context, state) {
              // Take token from parent widget (MerchantNavigateBottom)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<MerchantNavigateBottom>();
              final token = bottomWidget?.token ?? '';

              return MerchantHomePage(token: token);
            },
          ),

          GoRoute(
            path: "/merchant-restaurant-list",
            name: "merchant-restaurant-list",
            builder: (context, state) {
              // Take token from parent widget (MerchantNavigateBottom)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<MerchantNavigateBottom>();
              final token = bottomWidget?.token ?? '';

              return MerchantRestaurantList(token: token);
            },
          ),

          GoRoute(
            path: "/merchant-profile",
            name: "merchant-profile",
            builder: (context, state) {
              // Take token from parent widget (MerchantNavigateBottom)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<MerchantNavigateBottom>();
              final token = bottomWidget?.token ?? '';

              return MerchantProfile(token: token);
            },
          ),

          GoRoute(
            path: '/merchant-create-resaurant',
            builder: (context, state) {
              final token = state.extra as String;
              return CreateRestaurantPage(token: token);
            },
          ),
        ],
      ),

      // =============== RESTAURANT ===============
      ShellRoute(
        navigatorKey: _restaurantNavigatorKey,
        builder: (context, state, child) {
          // Take token from state.extra
          final token = state.extra is String ? state.extra as String : null;
          final restaurantId = state.pathParameters["id"]!;

          // Push token into MerchantNavigateBottom
          return RestaurantNavigateBottom(
            token: token,
            restaurantId: restaurantId,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: "/merchant/restaurant/:id/detail",
            name: "merchant-restaurant:id/detail",
            builder: (context, state) {
              // Take token from parent widget (RestaurantNavigateBottom)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<RestaurantNavigateBottom>();
              final token = bottomWidget?.token ?? '';
              final restaurantId = state.pathParameters["id"]!;

              return RestaurantDetailPage(
                restaurantId: restaurantId,
                token: token,
              );
            },
          ),

          GoRoute(
            path: "/merchant/restaurant/:id/orders",
            name: "merchant-restaurant:id/orders",
            builder: (context, state) {
              // Take token from parent widget (RestaurantNavigateBottom)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<RestaurantNavigateBottom>();
              final token = bottomWidget?.token ?? '';
              final restaurantId = int.parse(state.pathParameters["id"]!);

              return RestaurantOrder(restaurantId: restaurantId, token: token);
            },
          ),

          GoRoute(
            path: "/merchant/restaurant/:id/feedbacks",
            name: "merchant-restaurant:id/feedbacks",
            builder: (context, state) {
              // Take token from parent widget (RestaurantNavigateBottom)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<RestaurantNavigateBottom>();
              final token = bottomWidget?.token ?? '';
              final restaurantId = state.pathParameters["id"]!;

              return RestaurantFeedbackPage(
                restaurantId: restaurantId,
                token: token,
              );
            },
          ),

          GoRoute(
            path: "/merchant/restaurant/:id/create-menu",
            name: "merchant-restaurant:id/create-menu",
            builder: (context, state) {
              // Take token from parent widget (RestaurantNavigateBottom)
              final bottomWidget = context
                  .findAncestorWidgetOfExactType<RestaurantNavigateBottom>();
              final token = bottomWidget?.token ?? '';
              final restaurantId = state.pathParameters["id"]!;

              return CreateMenuPage(restaurantId: restaurantId, token: token);
            },
          ),
        ],
      ),

      GoRoute(
        path: '/restaurant/:restaurantId/orders/:orderId',
        name: "restaurant-orders-detail",
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>;
          final orderId = extraData['orderId'] as int;
          final token = extraData['token'] as String;

          return RestaurantOrderDetail(orderId: orderId, token: token);
        },
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
