import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chart_app/repositories/firebase_repository.dart';

String na, em;

class AuthService with ChangeNotifier {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  final FirebaseRepository firebaseRepository = FirebaseRepository();

  Future<auth.User> getUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('User signed in: ${user.email}');
      } else {
        print('No user signed in');
      }
      notifyListeners();
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signout() async {
    var result = await auth.FirebaseAuth.instance.signOut();
    print('Signing out user');
    notifyListeners();
    return result;
  }

  Future<auth.User> registerUserWithEmailAndPassword(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    var userCredential = await auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // FirebaseUser
    var newUser = userCredential.user;

    /// Add the first and last name to the FirebaseUser
    String newDisplayName = '$firstName $lastName';

    await newUser
        .updateProfile(displayName: newDisplayName)
        .catchError((error) => print(error));

    // Refresh data
    await newUser.reload();

    // Need to make this call to get the updated display name; or else display name will be null
    auth.User updatedUser = auth.FirebaseAuth.instance.currentUser;

    print('new display name: ${updatedUser.displayName}');
    na = newDisplayName;
    em = email;
    notifyListeners();

    // Return FirebaseUser with updated information (setting the display name using their first and last name)
    return updatedUser;
  }

  Future<auth.User> signInUserWithEmailAndPassword(
      {String email, String password}) async {
    try {
      var result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // since something changed, let's notify the listeners...
      notifyListeners();
      return result.user;
    } catch (firebaseAuthException) {
      throw new auth.FirebaseAuthException(
          message: firebaseAuthException.message,
          code: firebaseAuthException.code);
    }
  }

  
  
}
