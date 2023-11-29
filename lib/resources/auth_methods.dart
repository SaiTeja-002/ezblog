import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezblog/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
// import 'package:flutter_gram/models/user_model.dart' as UserModel;
import 'package:ezblog/models/user_model.dart' as UserModel;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get the current user details
  Future<UserModel.User> getUserDetails() async {
    User currentUser = await _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.User.fromSnap(snap);
  }

  // Create a new user
  Future<String> SingUp({
    required String email,
    required String userName,
    required String password,
    required Uint8List file,
  }) async {
    String creationStatus =
        "Some kind of error has occurred at the beginning itself";

    try {
      if (userName.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          file != null) {
        // Register the user in the Firebase Auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photourl = await StorageMethods()
            .uploadImageToStorage("ProfilePics", file, false);

        UserModel.User user = UserModel.User(
            email: email,
            uid: cred.user!.uid,
            photourl: photourl,
            userName: userName,
            type: "email");

        // Store the user credentials in the firebase database
        // Creates "users" collections if it doesn't already exist
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        creationStatus = "success";
      }
    } catch (err) {
      creationStatus = err.toString();
    }

    return creationStatus;
  } // SingUp

  // Login an existing user
  Future<String> login(
      {required String email, required String password}) async {
    String retMessage = "start of the login";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        retMessage = "success";
      } else {
        retMessage = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (err) {
      retMessage = err.toString();
    } catch (err) {
      retMessage = err.toString();
    }

    return retMessage;
  } // Login

  Future<void> signOut() async {
    await _auth.signOut();
  } // SignOut
}
