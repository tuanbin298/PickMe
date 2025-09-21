import 'package:flutter/material.dart';

class BaseAuthLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget form;
  final Widget? bottomSection;
  final Widget? topSection;
  final bool showGoogleButton;
  final VoidCallback? onGooglePressed;

  // Parameters for the layout
  const BaseAuthLayout({
    super.key,
    required this.title,
    required this.form,
    this.subtitle,
    this.bottomSection,
    this.topSection,
    this.showGoogleButton = false,
    this.onGooglePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Logo
              Center(
                child: Image.asset(
                  'lib/assets/images/pickme_logo.png',
                  width: 250,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              // Optional subtitle
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],

              // Optional topSection
              if (topSection != null) ...[
                const SizedBox(height: 8),
                topSection!,
              ],

              const SizedBox(height: 32),

              // Form section
              form,

              const SizedBox(height: 24),

              // Bottom section (e.g., forgot password, divider)
              if (bottomSection != null) ...[
                bottomSection!,
                const SizedBox(height: 16),
              ],

              // Google sign-in button
              if (showGoogleButton) ...[
                // Divider with "hoặc"
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "hoặc",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Google sign-in button
                OutlinedButton.icon(
                  onPressed: onGooglePressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  icon: Image.asset(
                    "lib/assets/logo/google_logo.png",
                    height: 24,
                  ),
                  label: const Text(
                    "Đăng nhập bằng Google",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),

                const SizedBox(height: 26),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
