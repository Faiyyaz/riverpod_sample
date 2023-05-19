import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../apis/auth_api.dart';
import '../../../apis/user_api.dart';
import '../../../core/core.dart';
import '../../../models/user_model.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, bool>(() {
  return AuthController();
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

final currentUserAccountStreamProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentUserStream();
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final User? user = ref.watch(currentUserAccountProvider).value;
  if (user != null) {
    final currentUserId = user.uid;
    final currentUserDetail = ref.watch(
      userDetailsProvider(
        currentUserId,
      ),
    );
    return currentUserDetail.value;
  } else {
    return null;
  }
});

/// Family is used when we need to pass parameter in the provider
final userDetailsProvider =
    FutureProvider.family<UserModel?, String>((ref, String? userId) {
  final AuthController authController = ref.read(
    authControllerProvider.notifier,
  );
  return authController.getUserData(userId);
});

// A class which exposes a state that can change over time.
// Difference between StateNotifier and Notifier is notifier doesn't give ref
// But enable us to get ref in custom functions
class AuthController extends AsyncNotifier<bool> {
  Future<User?> currentUser() async {
    final AuthAPI authAPI = ref.watch(authAPIProvider);
    final account = await authAPI.currentUserAccount();
    return account;
  }

  Stream<User?> getCurrentUserStream() {
    final AuthAPI authAPI = ref.read(authAPIProvider);
    final account = authAPI.listenCurrentUserAccount();
    return account;
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final AuthAPI authAPI = ref.read(authAPIProvider);
    state = const AsyncLoading();
    final Either<Failure, User?> response = await authAPI.signUp(
      email: email,
      password: password,
    );

    response.fold(
      (l) => state = AsyncError(l.message, l.stackTrace),
      (r) async {
        final value = await createUserDocument(
          email,
          r!.uid,
        );
        state = value;
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final AuthAPI authAPI = ref.read(authAPIProvider);
    state = const AsyncLoading();

    final Either<Failure, User?> response = await authAPI.login(
      email: email,
      password: password,
    );

    response.fold(
      (l) => state = AsyncError(l.message, l.stackTrace),
      (r) => state = const AsyncData(
        true,
      ),
    );
  }

  @override
  bool build() {
    return false;
  }

  Future<AsyncValue<bool>> createUserDocument(
    String email,
    String? userId,
  ) async {
    UserModel userModel = UserModel(
      email: email,
      name: getNameFromEmail(email),
      followers: const [],
      following: const [],
      profilePicture: '',
      bannerPicture: '',
      userId: userId ?? '',
      bio: '',
      isTwitterBlue: false,
    );
    final UserAPI userAPI = ref.read(userAPIProvider);
    final res = await userAPI.saveUserData(userModel);
    return res.fold(
      (l) => AsyncError(l.message, l.stackTrace),
      (r) => const AsyncData(true),
    );
  }

  Future<UserModel?> getUserData(
    String? userId,
  ) async {
    final UserAPI userAPI = ref.read(userAPIProvider);
    if (userId != null) {
      final UserModel? document = await userAPI.getUserData(userId);
      return document;
    } else {
      return null;
    }
  }
}
