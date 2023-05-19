import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<FirebaseAuth> firebaseAuthProvider = Provider(
  (ref) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return firebaseAuth;
  },
);

final Provider<FirebaseFirestore> cloudFirestoreProvider = Provider(
  (ref) {
    /// Interaction with other provider using ref
    /// ref.watch will be automatically updated anytime anything changes
    /// ref.read will be only one time change
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return firebaseFirestore;
  },
);
