// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pmgt/screens/home.dart';
import 'package:pmgt/services/authenticate.dart';
import 'package:pmgt/services/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String errorMessage;
  late String err;

  PMUser _userFormFirebaseUser(User? user) {
    return PMUser(uid: user!.uid);
  }

  Stream<PMUser> get user {
    return _firebaseAuth.authStateChanges().map(_userFormFirebaseUser);
  }

  handleAuth() {
    return StreamBuilder<PMUser>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData &&
              snapshot.data!.uid != null) {
            return const Home();
          } else if (!snapshot.hasData) {
            return const Authenticate();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future signInPlay(String email, String password) async {
    try {
      User? user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      return _userFormFirebaseUser(user);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          errorMessage = 'Your email address appears to be malformed.';
          break;
        case 'wrong-password':
          errorMessage = 'Your password is wrong.';
          break;
        case 'user-not-found':
          errorMessage = "User with this email doesn't exist.";
          break;
        case 'user-disabled':
          errorMessage = 'User with this email has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Try again later.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Signing in with Email and Password is not enabled.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid Credentials.';
          break;
        default:
          errorMessage = 'An undefined Error happened.';
      }
      if (errorMessage != '') {
        return Future.error(errorMessage);
      } else {
        return Future.error("Some error occured , Try again later.");
      }
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (error) {
      return null;
    }
  }
}
