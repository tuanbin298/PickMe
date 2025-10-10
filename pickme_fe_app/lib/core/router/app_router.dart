import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/auth/screens/forgot_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/otp_verification_page.dart';
import 'package:pickme_fe_app/features/auth/screens/reset_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/login_page.dart';
import 'package:pickme_fe_app/features/auth/screens/register_page.dart';
import 'package:pickme_fe_app/features/customer/screens/home_page.dart';
import 'package:pickme_fe_app/features/customer/screens/profile_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/home/merchant_home_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/merchant_navigate_bottom.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/merchant_restaurant/create_restaurant_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/merchant_restaurant/merchant_restaurant_list.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant/profile/merchant_profile.dart';
import 'package:pickme_fe_app/features/not_found/not_found_page.dart';

// Router configuration for the application
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

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

      GoRoute(
        path: "/home-page",
        name: "home-page",
        builder: (context, state) => const Homepage(),
      ),

      GoRoute(
        path: "/profile",
        name: "profile",
        builder: (context, state) => const ProfilePage(),
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
        ],
      ),

      GoRoute(
        path: "/merchant-create-resaurant",
        name: "merchant-create-resaurant",
        builder: (context, state) => const CreateRestaurantPage(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
