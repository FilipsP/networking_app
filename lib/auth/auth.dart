import 'package:firebase_auth/firebase_auth.dart';
import 'package:networking_app/db/firebase/controllers/firebase_user_controller.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final UserCredential userCredential;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<void> signInAnonymously() async {
    userCredential = await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> _delete() async {
    await _firebaseAuth.currentUser?.delete();
  }

  Future<void> handleSignIn(
      {required String email, required String password}) async {
    if (currentUser?.isAnonymous == true) {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _delete();
      await signInWithCredential(credential);
    } else {
      await signInWithEmailAndPassword(email: email, password: password);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithCredential(credential) async {
    userCredential = await _firebaseAuth.signInWithCredential(
      credential,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseUserController().writeNewUser(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email ?? '',
    );
  }

  Future<void> signOut() async {
    if (currentUser?.isAnonymous == true) {
      await _delete();
    }
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await _firebaseAuth.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
  }
}
