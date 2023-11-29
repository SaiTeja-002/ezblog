import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photourl;
  final String userName;
  final String type;

  const User({
    required this.email,
    required this.uid,
    required this.userName,
    required this.type,
    required this.photourl,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "photourl": photourl,
        "userName": userName,
        "type": type,
      };

  static User fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    return User(
      email: data['email'],
      uid: data['uid'],
      photourl: data['photourl'],
      userName: data['userName'],
      type: data['type'],
    );
  }
}
