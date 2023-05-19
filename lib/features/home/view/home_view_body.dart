import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/tweet/controller/tweet_controller.dart';
import 'package:twitter/models/tweet_model.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';
import '../../../models/create_tweet_response.dart';

// ConsumerWidget gives us ref
class HomeViewBody extends ConsumerWidget {
  const HomeViewBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tweetControllerProvider);
    return state.isLoading
        ? const LoadingPage()
        : ref.watch(tweetsStreamProvider).when(
              data: (tweets) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  itemBuilder: (itemContext, index) {
                    TweetModel? tweetModel = tweets.elementAt(index);
                    return ListTile(
                      title: Text(
                        tweetModel?.text ?? '',
                        style: const TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          handleTweetDelete(
                            tweetModel,
                            ref,
                            context,
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 30.0,
                        ),
                        color: Colors.red,
                      ),
                    );
                  },
                  itemCount: tweets!.length,
                );
              },
              error: (error, st) => ErrorPage(
                error: error.toString(),
              ),
              loading: () => const LoadingPage(),
            );
  }

  handleTweetDelete(
    TweetModel? tweetModel,
    WidgetRef ref,
    BuildContext context,
  ) async {
    CreateTweetResponse? createTweetResponse =
        await ref.read(tweetControllerProvider.notifier).deleteTweet(
              tweetId: tweetModel!.id,
            );
    if (createTweetResponse != null) {
      if (createTweetResponse.success) {
        if (context.mounted) {
          showSnackBar(context, 'Tweet Deleted Successfully');
        }
      } else {
        if (context.mounted) {
          showSnackBar(
            context,
            createTweetResponse.error ?? '',
          );
        }
      }
    }
  }
}
