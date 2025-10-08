import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/auth/screens/forgot_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/otp_verification_page.dart';
import 'package:pickme_fe_app/features/auth/screens/reset_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/login_page.dart';
import 'package:pickme_fe_app/features/auth/screens/register_page.dart';
import 'package:pickme_fe_app/features/customer/screens/home_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/create_restaurant/create_restaurant_intro.dart';
import 'package:pickme_fe_app/features/merchant/screens/create_restaurant/create_restaurant_page.dart';
import 'package:pickme_fe_app/features/customer/screens/profile_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant_navigate_page.dart';
import 'package:pickme_fe_app/features/not_found/not_found_page.dart';

// Router configuration for the application
class AppRouter {
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
      GoRoute(
        path: "/merchant-navigate",
        name: "merchant-navigate",
        builder: (context, state) => const MerchantNavigatePage(),
      ),

      GoRoute(
        path: "/merchant-intro",
        name: "merchant-intro",
        builder: (context, state) => const CreateRestaurantIntro(),
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
