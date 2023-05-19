import 'package:flutter/material.dart';

import '../../../common/common.dart';
import 'signup_view_body.dart';

class SignUpView extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );

  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReUsableAppBar(
        context: context,
      ),
      body: const SignUpViewBody(),
    );
  }
}
