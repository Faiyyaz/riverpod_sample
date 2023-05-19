import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/tweet_api.dart';
import '../../../features/auth/controller/auth_controller.dart';
import '../../../models/create_tweet_response.dart';
import '../../../models/tweet_model.dart';

final tweetControllerProvider =
    AsyncNotifierProvider<TweetController, CreateTweetResponse?>(() {
  return TweetController();
});

final tweetsStreamProvider = StreamProvider((ref) {
  final authController = ref.watch(tweetControllerProvider.notifier);
  return authController.getTweets();
});

// A class which exposes a state that can change over time.
// Difference between StateNotifier and Notifier is notifier doesn't give ref
// But enable us to get ref in custom functions
class TweetController extends AsyncNotifier<CreateTweetResponse?> {
  Future<CreateTweetResponse?> shareTweet({
    required String tweet,
  }) async {
    CreateTweetResponse? createTweetResponse;
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
        state = await AsyncValue.guard(() async {
          final res = await tweetAPI.shareTweet(
            tweetModel: tweetModel,
          );
          createTweetResponse = res.fold(
            (l) => CreateTweetResponse(
              success: false,
              error: l.message,
            ),
            (r) => const CreateTweetResponse(
              success: true,
              error: null,
            ),
          );

          return createTweetResponse;
        });
      }
    } else {
      state = await AsyncValue.guard(() async {
        createTweetResponse = const CreateTweetResponse(
          success: false,
          error: 'Please enter text',
        );
        return createTweetResponse;
      });
    }
    return createTweetResponse;
  }

  Stream<List<TweetModel?>?> getTweets() {
    final TweetAPI tweetAPI = ref.watch(tweetAPIProvider);
    final tweets = tweetAPI.getTweets();
    return tweets;
  }

  @override
  CreateTweetResponse? build() {
    return null;
  }

  Future<CreateTweetResponse?> deleteTweet({
    required String tweetId,
  }) async {
    CreateTweetResponse? createTweetResponse;
    state = const AsyncLoading();
    if (tweetId.isNotEmpty) {
      final currentUser = ref.watch(currentUserAccountProvider).value;
      if (currentUser != null) {
        final TweetAPI tweetAPI = ref.read(tweetAPIProvider);
        state = await AsyncValue.guard(() async {
          final res = await tweetAPI.deleteTweet(
            tweetId: tweetId,
          );
          createTweetResponse = res.fold(
            (l) => CreateTweetResponse(
              success: false,
              error: l.message,
            ),
            (r) => const CreateTweetResponse(
              success: true,
              error: null,
            ),
          );

          return createTweetResponse;
        });
      }
    } else {
      state = await AsyncValue.guard(() async {
        createTweetResponse = const CreateTweetResponse(
          success: false,
          error: 'Please enter text',
        );
        return createTweetResponse;
      });
    }
    return createTweetResponse;
  }
}
