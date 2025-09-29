import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/auth/screens/forgot_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/otp_verification_page.dart';
import 'package:pickme_fe_app/features/auth/screens/reset_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/login_page.dart';
import 'package:pickme_fe_app/features/auth/screens/register_page.dart';
import 'package:pickme_fe_app/features/customer/screens/home_page.dart';
import 'package:pickme_fe_app/features/customer/screens/profile_page.dart';
import 'package:pickme_fe_app/features/merchant/screens/merchant_home_page.dart';

// Router configuration for the application
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    routes: [
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
          final email =
              state.extra as String; // get email from ForgotPasswordPage
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

      GoRoute(
        path: "/merchant-home-page",
        name: "merchant-home-page",
        builder: (context, state) => const MerchantPage(),
      ),
    ],
  );
}
