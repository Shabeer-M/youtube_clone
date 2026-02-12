import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/service_locator.dart';
import '../main/main_page.dart';
import '../splash/splash_page.dart';
import '../auth/pages/login_page.dart';
import '../auth/pages/signup_page.dart';

import '../auth/pages/phone_login_page.dart';
import '../auth/pages/otp_verification_page.dart';
import '../auth/pages/reset_password_page.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../player/video_details_page.dart';
import '../downloads/downloads_page.dart';

import '../../domain/entities/video.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    refreshListenable: StreamListenable(sl<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = sl<AuthBloc>().state;
      final bool isLoggedIn = authState is AuthAuthenticated;

      final String location = state.matchedLocation;
      final bool isLoggingIn =
          location == '/login' ||
          location.startsWith('/login/') ||
          location == '/signup' ||
          location == '/welcome';

      // If on Splash, let SplashBloc handle navigation logic via listener
      // If on Splash, let SplashBloc handle navigation logic via listener
      if (location == '/') return null;

      if (!isLoggedIn && !isLoggingIn) {
        // Allow public access to home and its sub-routes (like video-details)
        if (location.startsWith('/home')) return null;
        return '/home';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/welcome', builder: (context, state) => const MainPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'phone',
            builder: (context, state) => const PhoneLoginPage(),
          ),
          GoRoute(
            path: 'verify-otp',
            builder: (context, state) => const OtpVerificationPage(),
          ),
          GoRoute(
            path: 'reset-password',
            builder: (context, state) => const ResetPasswordPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainPage(),
        routes: [
          GoRoute(
            path: 'video-details',
            builder: (context, state) {
              if (state.extra is Video) {
                final video = state.extra as Video;
                return VideoDetailsPage(video: video);
              }
              return const Scaffold(
                body: Center(child: Text('Error: Invalid video data')),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/downloads',
        builder: (context, state) => const DownloadsPage(),
      ),
    ],
  );
}

// Helper to make Bloc stream listenable for GoRouter
class StreamListenable extends ChangeNotifier {
  final Stream stream;

  StreamListenable(this.stream) {
    stream.listen((_) => notifyListeners());
  }
}
