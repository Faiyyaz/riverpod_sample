import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';
import '../../../models/auth_response.dart';
import '../../../theme/theme.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_field.dart';
import 'login_view.dart';

// ConsumerStatefulWidget gives us ref
class SignUpViewBody extends ConsumerStatefulWidget {
  const SignUpViewBody({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends ConsumerState<SignUpViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // .read Reads a provider without listening to it.
  Future<void> onSignUp() async {
    AuthResponse? authResponse =
        await ref.read(authControllerProvider.notifier).signUp(
              email: emailController.text,
              password: passwordController.text,
            );
    if (authResponse != null) {
      if (authResponse.success) {
        //TODO : Handled by auth changes
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
                            onSignUp();
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
                          text: 'Already have an account?',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushAndRemoveUntil(
                                      context,
                                      LoginView.route(),
                                      (route) => false,
                                    ),
                              text: ' Login',
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
