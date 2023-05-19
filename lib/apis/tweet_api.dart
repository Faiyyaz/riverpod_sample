import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../models/tweet_model.dart';
import '../constants/firebase_constants.dart';
import '../core/core.dart';

/// Provider is great for accessing dependencies that don't change,
/// such as the repositories in our app.
final Provider<TweetAPI> tweetAPIProvider = Provider((ref) {
  final FirebaseFirestore db = ref.watch(cloudFirestoreProvider);
  return TweetAPI(
    db: db,
  );
});

abstract class ITweetAPI {
  FutureEitherVoid shareTweet({
    required TweetModel tweetModel,
  });

  Stream<Object?> getTweets();
}

class TweetAPI implements ITweetAPI {
  final FirebaseFirestore _db;

  TweetAPI({
    required FirebaseFirestore db,
  }) : _db = db;

  @override
  FutureEitherVoid shareTweet({
    required TweetModel tweetModel,
  }) async {
    try {
      final tweetRef =
          _db.collection(FirebaseConstants.tweetsCollection).doc().id;
      final tweetDoc =
          _db.collection(FirebaseConstants.tweetsCollection).doc(tweetRef);
      tweetModel.id = tweetRef;
      await tweetDoc.set(
        tweetModel.toJson(),
        SetOptions(
          merge: true,
        ),
      );
      return right(null);
    } on FirebaseException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  Stream<List<TweetModel?>?> getTweets() {
    try {
      final tweets = _db
          .collection(FirebaseConstants.tweetsCollection)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          if (doc.exists) {
            return TweetModel.fromJson(doc.data());
          }
        }).toList();
      });
      return tweets;
    } on FirebaseException catch (_) {
      return Stream.value(null);
    } catch (e) {
      return Stream.value(null);
    }
  }

  FutureEitherVoid deleteTweet({
    required String tweetId,
  }) async {
    try {
      final tweetDoc = _db.collection(FirebaseConstants.tweetsCollection).doc(
            tweetId,
          );
      await tweetDoc.delete();
      return right(null);
    } on FirebaseException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }
}
