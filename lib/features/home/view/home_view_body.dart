import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/common.dart';
import '../../../core/utils.dart';
import '../../../features/tweet/controller/tweet_controller.dart';
import '../../../models/tweet_model.dart';

// ConsumerWidget gives us ref
class HomeViewBody extends ConsumerWidget {
  const HomeViewBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Listen for errors
    ref.listen<AsyncValue<void>>(
      tweetControllerProvider,
      (_, state) => state.when(
        error: (Object error, StackTrace stackTrace) {
          showSnackBar(context, error.toString());
        },
        data: (void data) {},
        loading: () {},
      ),
    );

    /// Listen for loading
    final isLoading = ref.watch(tweetControllerProvider).isLoading;
    return isLoading
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
    await ref.read(tweetControllerProvider.notifier).deleteTweet(
          tweetId: tweetModel!.id,
        );
  }
}
