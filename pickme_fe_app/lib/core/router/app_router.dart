import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/auth/screens/forgot_password_page.dart';
import 'package:pickme_fe_app/features/auth/screens/login_page.dart';
import 'package:pickme_fe_app/features/auth/screens/register_page.dart';
import 'package:pickme_fe_app/features/home/screens/home_page.dart';

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
        path: "/home-page",
        name: "home-page",
        builder: (context, state) => const Homepage(),
      ),
    ],
  );
}
