import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../apis/auth_api.dart';
import '../../../apis/user_api.dart';
import '../../../core/core.dart';
import '../../../models/auth_response.dart';
import '../../../models/user_model.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthResponse?>(() {
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
class AuthController extends AsyncNotifier<AuthResponse?> {
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

  Future<AuthResponse?> signUp({
    required String email,
    required String password,
  }) async {
    final AuthAPI authAPI = ref.read(authAPIProvider);
    AuthResponse? authResponse;
    String? userId;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final Either<Failure, User?> response = await authAPI.signUp(
        email: email,
        password: password,
      );

      authResponse = response.fold(
          (l) => AuthResponse(
                success: false,
                error: l.message,
              ), (r) {
        userId = r!.uid;
        return const AuthResponse(
          success: true,
          error: null,
        );
      });

      if (authResponse != null && authResponse!.success) {
        authResponse = await createUserDocument(
          email,
          userId,
        );
      }

      return authResponse;
    });
    return authResponse;
  }

  Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    final AuthAPI authAPI = ref.read(authAPIProvider);
    AuthResponse? authResponse;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final Either<Failure, User?> response = await authAPI.login(
        email: email,
        password: password,
      );

      authResponse = response.fold(
        (l) => AuthResponse(
          success: false,
          error: l.message,
        ),
        (r) => const AuthResponse(
          success: true,
          error: null,
        ),
      );
      return authResponse;
    });
    return authResponse;
  }

  @override
  AuthResponse? build() {
    return null;
  }

  Future<AuthResponse?> createUserDocument(
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
      (l) => AuthResponse(
        success: false,
        error: l.message,
      ),
      (r) => const AuthResponse(
        success: true,
        error: null,
      ),
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
