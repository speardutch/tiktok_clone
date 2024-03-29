import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/generated/l10n.dart';

import 'widgets/auth_button.dart';

class SignUpScreen extends ConsumerWidget {
  static String routeURL = "/";
  static String routeName = "signUp";

  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) async {
    context.pushNamed(LoginScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(
      builder: ((context, orientation) {
        print(orientation);
        return Scaffold(
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
            child: Column(
              children: [
                Gaps.v80,
                Text(
                  S.of(context).signUpTitle("TikTok", DateTime.now()),
                  style: const TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v20,
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    S.of(context).signUpSubtitle(3),
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.v40,
                if (orientation == Orientation.portrait) ...[
                  GestureDetector(
                    onTap: () => _onEmailTap(context),
                    child: AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.user),
                        text: S.of(context).emailPasswordButton),
                  ),
                  Gaps.v16,
                  GestureDetector(
                    onTap: () => ref
                        .read(socialAuthProvider.notifier)
                        .githubSignIn(context),
                    child: const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.github),
                        text: "Continue with Github"),
                  ),
                ],
                if (orientation == Orientation.landscape)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onEmailTap(context),
                          child: AuthButton(
                              icon: const FaIcon(FontAwesomeIcons.user),
                              text: S.of(context).emailPasswordButton),
                        ),
                      ),
                      Gaps.h16,
                      const Expanded(
                        child: AuthButton(
                            icon: FaIcon(FontAwesomeIcons.github),
                            text: "Continue with Github"),
                      ),
                    ],
                  ),
              ],
            ),
          )),
          bottomNavigationBar: Container(
            color: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                bottom: Sizes.size64,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: Text(
                      S.of(context).logIn("male"),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
