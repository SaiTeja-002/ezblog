// CHAT-GPT CODE FOR STREAM BUILDER

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezblog/pages/blog_card.dart';
import 'package:ezblog/pages/login_page.dart';
import 'package:ezblog/resources/auth_methods.dart';
import 'package:ezblog/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  bool isLoading = false;
  int publishedBlogsLen = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      var blogSnap = await FirebaseFirestore.instance
          .collection("blogs")
          .where("uid", isEqualTo: widget.uid)
          .get();

      setState(() {
        publishedBlogsLen = blogSnap.docs.length;
        userData = userSnap.data()!;
        isLoading = false;
      });

      print(userData);
    } catch (err) {
      showSnackBar(err.toString(), context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.grey[400],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthMethods().signOut();
              showSnackBar("Logout succesfull!", context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                          .copyWith(right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(userData["photourl"]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  userData["userName"],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),

                // email
                const SizedBox(height: 20),
                Text(
                  userData["email"],
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Provider
                const SizedBox(height: 20),
                Text(
                  "Provider - ${userData["type"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Blogs",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey[400],
                  indent: 10,
                  endIndent: MediaQuery.of(context).size.width * 0.5,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("blogs")
                      .where("uid", isEqualTo: widget.uid)
                      // .orderBy("datepublished", descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No blogs found.'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final blogDoc = snapshot.data!.docs[index];
                        if (blogDoc.exists) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              BlogCard(
                                snap: blogDoc,
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox(); // Placeholder for empty data
                        }
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
