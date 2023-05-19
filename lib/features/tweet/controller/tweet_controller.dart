import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/tweet_api.dart';
import '../../../features/auth/controller/auth_controller.dart';
import '../../../models/tweet_model.dart';

final tweetControllerProvider =
    AsyncNotifierProvider<TweetController, bool>(() {
  return TweetController();
});

final tweetsStreamProvider = StreamProvider((ref) {
  final authController = ref.watch(tweetControllerProvider.notifier);
  return authController.getTweets();
});

// A class which exposes a state that can change over time.
// Difference between StateNotifier and Notifier is notifier doesn't give ref
// But enable us to get ref in custom functions
class TweetController extends AsyncNotifier<bool> {
  Future<void> shareTweet({
    required String tweet,
  }) async {
    state = const AsyncLoading();
    if (tweet.isNotEmpty) {
      final currentUser = ref.watch(currentUserAccountProvider).value;
      if (currentUser != null) {
        String userId = currentUser.uid;
        TweetModel tweetModel = TweetModel(
          text: tweet,
          id: '',
          userid: userId,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          tweetType: 'text',
        );
        final TweetAPI tweetAPI = ref.read(tweetAPIProvider);
        final res = await tweetAPI.shareTweet(
          tweetModel: tweetModel,
        );

        res.fold(
          (l) => state = AsyncError(l.message, l.stackTrace),
          (r) => state = const AsyncData(
            true,
          ),
        );
      }
    } else {
      state = AsyncError(
        'Please enter text',
        StackTrace.current,
      );
    }
  }

  Stream<List<TweetModel?>?> getTweets() {
    final TweetAPI tweetAPI = ref.watch(tweetAPIProvider);
    final tweets = tweetAPI.getTweets();
    return tweets;
  }

  @override
  bool build() {
    return false;
  }

  Future<void> deleteTweet({
    required String tweetId,
  }) async {
    state = const AsyncLoading();
    if (tweetId.isNotEmpty) {
      final currentUser = ref.watch(currentUserAccountProvider).value;
      if (currentUser != null) {
        final TweetAPI tweetAPI = ref.read(tweetAPIProvider);
        final res = await tweetAPI.deleteTweet(
          tweetId: tweetId,
        );

        res.fold(
          (l) => state = AsyncError(l.message, l.stackTrace),
          (r) => state = const AsyncData(
            true,
          ),
        );
      }
    } else {
      state = AsyncError(
        'Please send tweet id',
        StackTrace.current,
      );
    }
  }
}
