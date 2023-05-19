import 'package:flutter/material.dart';

import '../../../common/common.dart';
import '../../../theme/theme.dart';
import '../../tweet/view/create_tweet_view.dart';
import 'home_view_body.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );

  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReUsableAppBar(
        context: context,
      ),
      body: const HomeViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CreateTweetView.route(),
          );
        },
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28.0,
        ),
      ),
    );
  }
}
