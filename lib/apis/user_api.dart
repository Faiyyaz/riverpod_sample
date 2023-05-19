import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/constants.dart';
import '../core/core.dart';
import '../models/user_model.dart';

/// Provider is great for accessing dependencies that don't change,
/// such as the repositories in our app.
final Provider<UserAPI> userAPIProvider = Provider((ref) {
  final FirebaseFirestore db = ref.watch(cloudFirestoreProvider);
  return UserAPI(
    db: db,
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(
    UserModel userModel,
  );

  Future<UserModel?> getUserData(
    String userId,
  );
}

class UserAPI implements IUserAPI {
  final FirebaseFirestore _db;

  UserAPI({
    required FirebaseFirestore db,
  }) : _db = db;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      final userDoc = _db
          .collection(FirebaseConstants.usersCollection)
          .doc(userModel.userId);
      await userDoc.set(
        userModel.toJson(),
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
  Future<UserModel?> getUserData(String userId) async {
    final userDoc = _db.collection(FirebaseConstants.usersCollection).doc(
          userId,
        );
    final DocumentSnapshot<Map<String, dynamic>> user = await userDoc.get();
    if (user.exists && user.data() != null) {
      return UserModel.fromJson(user.data()!);
    } else {
      return null;
    }
  }
}
