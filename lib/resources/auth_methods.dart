import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezblog/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
// import 'package:flutter_gram/models/user_model.dart' as UserModel;
import 'package:ezblog/models/user_model.dart' as UserModel;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get the current user details
  Future<UserModel.User> getUserDetails() async {
    User currentUser = await _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.User.fromSnap(snap);
  } //Get User Details

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

  // Google Signin
  Future<String> GoogleSignin() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    String ret = "Error at the beginning itself!";

    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(forceCodeForRefreshToken: true).signIn();

      if (googleUser != null) {
        print('Signed in: ${googleUser.displayName}');
        ret = "signin success!";

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // String photourl = await StorageMethods()
        //     .uploadImageToStorage("ProfilePics", user., false);

        UserCredential cred = await _auth.signInWithCredential(credential);
        User? user = cred.user;

        await _firestore.collection("users").doc(cred.user!.uid).set({
          'email': user!.email,
          'uid': user.uid,
          'photourl': user.photoURL,
          'userName': user.displayName,
          'type': "google",
        });

        ret = "success";
      } else {
        // Handle sign in failure
        print('Sign in failed');
        ret = "some error occurred";
      }
    } catch (error) {
      // Handle sign in error
      print('Error signing in: $error');
      ret = error.toString();
    } // Google signin

    return ret;
  }

  Future<String> FacebookSignin() async {
    String ret = "Error at the beginning itself!";

    try {
      print("called facebook auth");
      await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final graphResponse = await http.get(
          Uri.parse(
              'https://graph.facebook.com/v14.0/me?fields=id,name,email,picture'),
          headers: {'Authorization': 'Bearer ${accessToken.token}'},
        );

        final Map<String, dynamic> userData = json.decode(graphResponse.body);

        String facebookName = userData['name'] ?? '';
        String facebookEmail = userData['email'] ?? '';
        String facebookPictureUrl = userData['picture']['data']['url'] ?? '';

        final AuthCredential creds =
            FacebookAuthProvider.credential(result.accessToken!.token);

        UserCredential auth = await _auth.signInWithCredential(creds);

        DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(auth.user?.uid).get();

        if (userDoc.exists) {
          print('User Already Exist: Updating Only Facebook');
          await _firestore.collection("users").doc(auth.user?.uid).update({
            'facebook': facebookEmail,
          });
        } else {
          await _firestore.collection("users").doc(auth.user?.uid).set({
            "userName": facebookName,
            'email': facebookEmail,
            'type': "facebook",
            'uid': auth.user?.uid,
            // 'photourl': facebookPictureUrl,
            'photourl':
                "https://upload.wikimedia.org/wikipedia/commons/6/6c/Facebook_Logo_2023.png"
          });
        }

        ret = "success";
      } else if (result.status == LoginStatus.cancelled) {
        print("Facebook login cancelled");
        ret = "auth cancelled";
      } else {
        print("Facebook login failed: ${result.message}");
        ret = result.message.toString();
      }

      return ret;
    } catch (e) {
      print("Facebook login error: $e");
      return e.toString();
    }
  }
}
