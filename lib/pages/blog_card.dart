import 'package:ezblog/pages/create_blog.dart';
import 'package:ezblog/pages/detailed_blog_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ezblog/utils/utils.dart';

class BlogCard extends StatefulWidget {
  final snap;
  const BlogCard({
    super.key,
    required this.snap,
  });

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  @override
  Widget build(BuildContext context) {
    final bloguid = widget.snap["uid"];

    bool isCurrentUserAuthor =
        FirebaseAuth.instance.currentUser!.uid == bloguid;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlogDetailPage(snap: widget.snap)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Padding(
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
                        radius: 16,
                        backgroundImage: NetworkImage(
                            // "https://i.pinimg.com/custom_covers/222x/85498161615209203_1636332751.jpg"
                            widget.snap["profimg"]),
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
                      // IconButton(
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => Dialog(
                      //         child: ListView(
                      //           padding: const EdgeInsets.symmetric(
                      //             vertical: 16,
                      //           ),
                      //           shrinkWrap: true,
                      //           children: ["Edit", "Delete"]
                      //               .map(
                      //                 (e) => InkWell(
                      //                   onTap: () {},
                      //                   child: Container(
                      //                     padding: const EdgeInsets.symmetric(
                      //                         vertical: 12, horizontal: 16),
                      //                     child: Text(e),
                      //                   ),
                      //                 ),
                      //               )
                      //               .toList(),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   icon: const Icon(Icons.more_vert_rounded),
                      // ),

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
                                        bool confirmDeletion = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                const Text('Confirm Deletion'),
                                            content: const Text(
                                                'Are you sure you want to delete this blog post?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
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
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(
                                            //   const SnackBar(
                                            //     content:
                                            //         Text('Blog post deleted'),
                                            //   ),
                                            // );
                                            showSnackBar(
                                                "blog has been deleted Succesfully!",
                                                context);
                                          } catch (error) {
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(
                                            //   SnackBar(
                                            //     content: Text(
                                            //         'Error deleting blog post: $error'),
                                            //   ),
                                            // );
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
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                          // "https://plus.unsplash.com/premium_photo-1681412205172-8c06ca667689?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=500&q=60",
                          // "https://images.unsplash.com/photo-1690484813045-d27df776bc8c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHx8&auto=format&fit=crop&w=500&q=60",
                          widget.snap["posturl"],
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
                    // "This is a huge title and let's see how it behaves in multiple lines",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Row - 4 : Description
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 15, left: 15, right: 15),
                  child: Text(
                    widget.snap["content"],
                    // "This is the description. It can be a longer text that is to be truncated if it's too long. This is the description. It can be a longer text that needs to be truncated if it's too long.",
                    maxLines: 2,
                    // Display ellipsis (...) if text overflows
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
