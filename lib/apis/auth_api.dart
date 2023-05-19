import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../core/core.dart';

/// Provider is great for accessing dependencies that don't change,
/// such as the repositories in our app.
final Provider<AuthAPI> authAPIProvider = Provider((ref) {
  final FirebaseAuth account = ref.watch(firebaseAuthProvider);
  return AuthAPI(
    account: account,
  );
});

abstract class IAuthAPI {
  FutureEither<User?> signUp({
    required String email,
    required String password,
  });

  FutureEither<User?> login({
    required String email,
    required String password,
  });

  Future<User?> currentUserAccount();

  Stream<User?> listenCurrentUserAccount();
}

class AuthAPI implements IAuthAPI {
  final FirebaseAuth _account;

  AuthAPI({
    required FirebaseAuth account,
  }) : _account = account;

  @override
  FutureEither<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(account.user);
    } on FirebaseAuthException catch (e, stackTrace) {
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
  FutureEither<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(session.user);
    } on FirebaseAuthException catch (e, stackTrace) {
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
  Future<User?> currentUserAccount() async {
    try {
      final account = _account.currentUser;
      return account;
    } on FirebaseAuthException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<User?> listenCurrentUserAccount() {
    try {
      final account = _account.authStateChanges();
      return account;
    } on FirebaseAuthException catch (_) {
      return Stream.value(null);
    } catch (e) {
      return Stream.value(null);
    }
  }
}
