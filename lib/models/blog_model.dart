import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String title;
  final String content;
  final String uid;
  final String userName;
  final String postid; // unique post ID generated using uuid
  final datePublished;
  final String posturl; // URL of the uploaded image in Storage
  final String profImg; // URL of the user

  const Blog(
      {required this.title,
      required this.content,
      required this.uid,
      required this.userName,
      required this.postid,
      required this.datePublished,
      required this.posturl,
      required this.profImg});

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "uid": uid,
        "username": userName,
        "datepublished": datePublished,
        "posturl": posturl,
        "postid": postid,
        "profimg": profImg,
      };

  static Blog fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    return Blog(
      title: data["title"],
      content: data["content"],
      uid: data["uid"],
      userName: data["username"],
      datePublished: data["datepublished"],
      posturl: data["posturl"],
      postid: data["postid"],
      profImg: data["profimg"],
    );
  }
}
