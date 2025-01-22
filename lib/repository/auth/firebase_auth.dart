import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class Auth {
  Auth() {
    initializeApp();
  }

  Future<void> registerWithEmailPassword(String email, String password) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = userCredential.user;
      print("User registered: ${user!.uid}");
    } catch (e) {
      print("Error registering user: $e");
    }
  }

  Future<void> initializeApp() async {
    await Firebase.initializeApp();
  }

  Future<void> signInWithPhone(
      String phoneNumber,
      BuildContext context,
      Function onCodeSent,
      Function(String) onError) async {
    Logger().i('Phone number: $phoneNumber');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("Phone auto-retrieval or instant sign-in completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        onError("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        print("Code sent to $phoneNumber");
        onCodeSent(verificationId, resendToken);   
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Code auto-retrieval timeout");
      },
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      var user = userCredential.user;

      print("Google sign-in successful, User UID: ${user!.uid}");
    } catch (e) {
      print("Google sign-in failed: $e");
    }
  }
}
 
