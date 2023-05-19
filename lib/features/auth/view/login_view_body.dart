import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';
import '../../../theme/theme.dart';
import '../../home/view/home_view.dart';
import '../controller/auth_controller.dart';
import '../../../models/auth_response.dart';
import '../view/signup_view.dart';
import '../widgets/auth_field.dart';

// ConsumerStatefulWidget gives us ref
class LoginViewBody extends ConsumerStatefulWidget {
  const LoginViewBody({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends ConsumerState<LoginViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // .read Reads a provider without listening to it.
  Future<void> onLogin() async {
    AuthResponse? authResponse =
        await ref.read(authControllerProvider.notifier).login(
              email: emailController.text,
              password: passwordController.text,
            );
    if (authResponse != null) {
      if (authResponse.success) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            HomeView.route(),
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, authResponse.error ?? '');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    return Container(
      child: state.isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Column(
                    children: [
                      AuthField(
                        textEditingController: emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      AuthField(
                        textEditingController: passwordController,
                        hintText: 'Password ',
                        hideText: true,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: RoundedSmallButton(
                          onTap: () {
                            onLogin();
                          },
                          label: 'Done',
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushAndRemoveUntil(
                                      context,
                                      SignUpView.route(),
                                      (route) => false,
                                    ),
                              text: ' Sign up',
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
