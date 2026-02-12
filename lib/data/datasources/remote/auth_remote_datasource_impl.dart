import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/user.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;

  String? _verificationId;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<User> loginWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(credential.user!);
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Login failed');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted:
            (firebase.PhoneAuthCredential credential) async {},
        verificationFailed: (firebase.FirebaseAuthException e) {
          throw AuthFailure(e.message ?? 'Phone verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<User> verifyOtp(String otp, String? verificationId) async {
    final id = verificationId ?? _verificationId;
    if (id == null) {
      throw const AuthFailure('Verification ID not found. Request OTP first.');
    }

    try {
      final credential = firebase.PhoneAuthProvider.credential(
        verificationId: id,
        smsCode: otp,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return _mapFirebaseUser(userCredential.user!);
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'OTP Verification failed');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Reset password failed');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return _mapFirebaseUser(user);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    // await GoogleSignIn().signOut(); // Optional: sign out from Google as well
  }

  @override
  Future<User> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        throw const AuthFailure('Google Sign-In aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      final firebase.UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      return _mapFirebaseUser(userCredential.user!);
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Google Sign-In failed');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<User> registerWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      final updatedUser = _firebaseAuth.currentUser;
      return _mapFirebaseUser(updatedUser!);
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Registration failed');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  User _mapFirebaseUser(firebase.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      profileImageUrl: firebaseUser.photoURL,
    );
  }
}
