import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/email_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/onboarding/interest_screen.dart';
import 'package:tiktok_clone/features/users/user_profile_screen.dart';
import 'package:tiktok_clone/features/videos/video_recording_screen.dart';

final router = GoRouter(routes: [
  GoRoute(
    name: SignUpScreen.routeName,
    path: SignUpScreen.routeURL,
    builder: (context, state) => const SignUpScreen(),
  ),
  GoRoute(
    name: LoginScreen.routeName,
    path: LoginScreen.routeURL,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: InterestScreen.routeName,
    path: InterestScreen.routeURL,
    builder: (context, state) => const InterestScreen(),
  ),
  GoRoute(
    name: MainNavigationScreen.routeName,
    path: "/:tab(home|discover|index|profile)",
    builder: (context, state) {
      final tab = state.params["tab"]!;
      return MainNavigationScreen(tab: tab);
    },
  ),
]);
