import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/common.dart';
import '../../../core/utils.dart';
import '../../../theme/theme.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/tweet_controller.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateTweetView(),
      );
  const CreateTweetView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetView> {
  final TextEditingController _tweetTextController = TextEditingController();

  @override
  void dispose() {
    _tweetTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;

    /// Listen for errors
    ref.listen<AsyncValue<void>>(
      tweetControllerProvider,
      (_, state) => state.when(
        error: (Object error, StackTrace stackTrace) {
          showSnackBar(context, error.toString());
        },
        data: (void data) {
          showSnackBar(context, 'Tweet Created Successfully');
          Navigator.pop(context);
        },
        loading: () {},
      ),
    );

    /// Listen for loading
    final isLoading = ref.watch(tweetControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Pallete.whiteColor,
            size: 30.0,
          ),
        ),
        actions: [
          RoundedSmallButton(
            onTap: () async {
              await ref.read(tweetControllerProvider.notifier).shareTweet(
                    tweet: _tweetTextController.text,
                  );
            },
            label: 'Tweet',
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                            currentUser.profilePicture ?? '',
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _tweetTextController,
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'What\'s happening?',
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
