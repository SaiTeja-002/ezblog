import 'dart:typed_data';
import 'package:ezblog/models/blog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezblog/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new blog post
  Future<String> createBlog(String title, String content, Uint8List file,
      String uid, String userName, String profImg) async {
    String res = "Error at the beginning itself!";

    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String blogId = const Uuid().v1();

      Blog blog = Blog(
        title: title,
        content: content,
        posturl: postUrl,
        postid: blogId,
        uid: uid,
        userName: userName,
        profImg: profImg,
        datePublished: DateTime.now(),
      );

      _firestore.collection('blogs').doc(blogId).set(blog.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
  // End of create new blog

  // Update an existing blog post
  Future<String> updateBlog(
    String blogId,
    String newTitle,
    String newContent,
    Uint8List newImage,
  ) async {
    String res = "Error updating the blog in the beginning itself!";

    try {
      String newPostUrl = "";

      if (newImage != null) {
        newPostUrl = await StorageMethods()
            .uploadImageToStorage("blogs", newImage, true);
      }

      Map<String, dynamic> updatedData = {
        'title': newTitle,
        'content': newContent,
        if (newPostUrl != null) 'posturl': newPostUrl,
      };

      await _firestore.collection('blogs').doc(blogId).update(updatedData);

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
  // End of update blog

  // Post a new comment
  Future<String> postComment(
    String postId,
    String uid,
    String content,
    String porfImg,
    String username,
  ) async {
    String res = "Start of postComment";

    print(res);

    try {
      String commentId = const Uuid().v1();

      if (content.isNotEmpty) {
        await _firestore
            .collection("blogs")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilepic": porfImg,
          "name": username,
          "content": content,
          "uid": uid,
          "commentid": commentId,
          "datepublished": DateTime.now(),
        });
      } else {
        res = "empty comment";
      }
    } catch (err) {
      res = err.toString();
    }

    print("res - ${res}");

    return res;
  }
  // End of Posting a comment
}
