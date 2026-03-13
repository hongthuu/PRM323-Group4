import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_services.dart';
import '../home/main_screen.dart';
import 'login_screen.dart';

/// Resolve authentication state and navigate to correct screen
class AuthResolver extends StatelessWidget {
  const AuthResolver({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to Firebase authentication state
    final authStream = FirebaseAuth.instance.authStateChanges();

    return StreamBuilder<User?>(
      stream: authStream,
      builder: (context, snapshot) {
        /// While checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        /// If user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          final User user = snapshot.data!;
          final AuthService authService = AuthService();

          // Fetch user role before navigating to home screen
          return FutureBuilder<String>(
            future: authService.getUserRole(user.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  ),
                );
              }

              // Default role fallback
              final String role = roleSnapshot.data ?? 'student';

              return HomeScreen(role: role);
            },
          );
        }

        /// If no user -> show login screen
        return const LoginScreen();
      },
    );
  }
}
