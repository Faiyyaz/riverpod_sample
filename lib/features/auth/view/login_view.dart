import 'package:flutter/material.dart';

import '../../../common/common.dart';
import 'login_view_body.dart';

class LoginView extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );

  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReUsableAppBar(
        context: context,
      ),
      body: const LoginViewBody(),
    );
  }
}
