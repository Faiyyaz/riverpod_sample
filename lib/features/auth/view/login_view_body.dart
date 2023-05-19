import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';

import '../../../common/common.dart';
import '../../../theme/theme.dart';
import '../controller/auth_controller.dart';
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
    await ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    /// Listen for errors
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (_, state) => state.when(
        error: (Object error, StackTrace stackTrace) {
          debugPrint('hello');
          showSnackBar(context, error.toString());
        },
        data: (void data) {
          debugPrint('data hello');
        },
        loading: () {
          debugPrint('loading hello');
        },
      ),
    );

    /// Listen for loading
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Container(
      child: isLoading
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
