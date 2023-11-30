import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';

import 'widgets/auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  void _onEmailTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UsernameScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
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
                  "Sign up for TikTok",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.red,
                      ),
                ),
                Gaps.v20,
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    "Create a profile, follow other accounts, make your own videos, and more.",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.v40,
                if (orientation == Orientation.portrait) ...[
                  GestureDetector(
                    onTap: () => _onEmailTap(context),
                    child: const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.user),
                        text: "Use email or password"),
                  ),
                  Gaps.v16,
                  const AuthButton(
                      icon: FaIcon(FontAwesomeIcons.apple),
                      text: "Continue with Apple"),
                ],
                if (orientation == Orientation.landscape)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onEmailTap(context),
                          child: const AuthButton(
                              icon: FaIcon(FontAwesomeIcons.user),
                              text: "Use email or password"),
                        ),
                      ),
                      Gaps.h16,
                      const Expanded(
                        child: AuthButton(
                            icon: FaIcon(FontAwesomeIcons.apple),
                            text: "Continue with Apple"),
                      ),
                    ],
                  ),
              ],
            ),
          )),
          bottomNavigationBar: BottomAppBar(
            color: Colors.grey.shade50,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: Text(
                      "Log in",
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
