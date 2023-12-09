import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezblog/pages/blog_card.dart';
import 'package:ezblog/pages/create_blog.dart';
import 'package:ezblog/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ezblog/utils/utils.dart';

class BlogDetailPage extends StatefulWidget {
  final snap;
  const BlogDetailPage({
    super.key,
    required this.snap,
  });

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  Future<String> getUsername() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return userDoc['userName'];
  }

  Future<String> getProfImg() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return userDoc['photourl'];
  }

  Future<void> postComment(comment) async {
    String username = await getUsername();
    String profImg = await getProfImg();
    // String comment = _commentController.text;

    print("function");

    print(username);
    print(comment);

    if (comment.isNotEmpty) {
      print("comment is not empty!");

      String ret = await FirestoreMethods().postComment(
        widget.snap["postid"],
        FirebaseAuth.instance.currentUser!.uid,
        comment,
        profImg,
        username,
      );

      print("Complete call to the backend!");
      print(ret);

      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloguid = widget.snap["uid"];

    bool isCurrentUserAuthor =
        FirebaseAuth.instance.currentUser!.uid == bloguid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.grey[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Column(
                children: [
                  // Row-1 : User Avatar, UserName, VertButton
                  // r1 - user avatar
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                            .copyWith(right: 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(widget.snap["profimg"]),
                        ),

                        // r1 - username
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.snap["username"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // r1 - Expanded VertButton
                        if (isCurrentUserAuthor)
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shrinkWrap: true,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateBlog(
                                                          snap: widget.snap)));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: const Text('Edit'),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          bool confirmDeletion =
                                              await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Confirm Deletion'),
                                              content: const Text(
                                                  'Are you sure you want to delete this blog post?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirmDeletion == true) {
                                            try {
                                              await widget.snap.reference
                                                  .delete();
                                              showSnackBar(
                                                  "blog has been deleted Succesfully!",
                                                  context);
                                            } catch (error) {
                                              showSnackBar(
                                                  error.toString(), context);
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: const Text('Delete'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.more_vert_rounded),
                          ),
                      ],
                    ),
                  ),

                  // Row-2 : Blog Banner Image
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      // width: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(15),
                        child: Image.network(widget.snap["posturl"],
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  // Row-3 : Title
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 15, left: 16, right: 16),
                    child: Text(
                      widget.snap["title"],
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Row - 4 : Description
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 15, left: 15, right: 15),
                    child: Text(
                      widget.snap["content"],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),

            // Row-5 : New Comment
            // TextField for adding a new comment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String comment = _commentController.text.trim();
                      print("comment read from input field");

                      if (comment.isNotEmpty) {
                        print("passing this comment to a function");
                        postComment(comment);
                        print("passed this comment");
                        // _commentController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),

            // Row-6 : List of comments on this blog
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("blogs")
                  .doc(widget.snap["postid"])
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No comments yet.');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.docs.map((commentDoc) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(commentDoc['profilepic']),
                      ),
                      title: Text(commentDoc['content']),
                      subtitle: Text(commentDoc['name']),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
