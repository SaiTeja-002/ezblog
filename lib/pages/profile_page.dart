// // Also works for mutable list of blogs
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ezblog/pages/blog_card.dart';
// import 'package:ezblog/pages/login_page.dart';
// import 'package:ezblog/resources/auth_methods.dart';
// import 'package:ezblog/utils/utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   final String uid;
//   // const ProfilePage({Key? key}) : super(key: key);
//   const ProfilePage({
//     super.key,
//     required this.uid,
//   });

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   var userData = {}, blogData = {};
//   bool isLoading = false;
//   int publishedBlogsLen = 0;

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   void getData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var userSnap = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(widget.uid)
//           .get();

//       var blogSnap = await FirebaseFirestore.instance
//           .collection("blogs")
//           .where("uid", isEqualTo: widget.uid)
//           .get();

//       publishedBlogsLen = blogSnap.docs.length;

//       userData = userSnap.data()!;
//       // blogData = blogSnap.data()!;

//       setState(() {});
//     } catch (err) {
//       showSnackBar(err.toString(), context);
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : Scaffold(
//             appBar: AppBar(
//               title: const Text('Profile'),
//               backgroundColor: Colors.grey[400],
//               automaticallyImplyLeading: false,
//               actions: [
//                 IconButton(
//                   onPressed: () async {
//                     await AuthMethods().signOut();
//                     showSnackBar("Logout succesfull!", context);
//                     print("Logout");
//                     Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context) => LoginScreen()));
//                   },
//                   icon: const Icon(Icons.logout_rounded),
//                 ),
//                 // Center(child: const Text("Logout")),
//               ],
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // User Profile Picture
//                   Padding(
//                     padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).size.height * 0.03),
//                     child: Center(
//                       child: CircleAvatar(
//                         // backgroundImage: NetworkImage(
//                         // "https://4kwallpapers.com/images/wallpapers/levi-ackerman-1680x1050-10437.png"),
//                         backgroundColor: Colors.black,
//                         backgroundImage: NetworkImage(userData["photourl"]),
//                         radius: 70,
//                       ),
//                     ),
//                   ),

//                   // UserName
//                   const SizedBox(height: 30),
//                   Text(
//                     userData["userName"],
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w600, fontSize: 25),
//                   ),

//                   // User Written Blogs Section
//                   const SizedBox(height: 20), // Adjusted the height
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Text(
//                           "Blogs - ${publishedBlogsLen}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                       // Text("${blogPostCards.length}"),
//                     ],
//                   ),

//                   // Horizontal Ruler
//                   Divider(
//                     thickness: 2,
//                     color: Colors.grey[400],
//                     indent: 10,
//                     endIndent: MediaQuery.of(context).size.width * 0.5,
//                   ),

//                   // List of blogs published by the user
//                   const SizedBox(height: 20),

//                   StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection("blogs")
//                         .orderBy("datepublished", descending: true)
//                         .snapshots(),
//                     builder: (context,
//                         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                             snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }

//                       return ListView.builder(
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           return Column(
//                             children: [
//                               const SizedBox(height: 20),
//                               BlogCard(
//                                 snap: snapshot.data!.docs[index],
//                               ),
//                               (index == snapshot.data!.docs.length - 1)
//                                   ? SizedBox(height: 20)
//                                   : Container(),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),

//                   // FutureBuilder(
//                   //   future: FirebaseFirestore.instance
//                   //       .collection("blogs")
//                   //       .where("uid", isEqualTo: widget.uid)
//                   //       .get(),
//                   //   builder: (context, snapshot) {
//                   //     if (snapshot.connectionState == ConnectionState.waiting) {
//                   //       return const Center(child: CircularProgressIndicator());
//                   //     } else if (snapshot.hasError) {
//                   //       return Center(child: Text('Error: ${snapshot.error}'));
//                   //     } else if (!snapshot.hasData ||
//                   //         snapshot.data!.docs.isEmpty) {
//                   //       return Center(child: Text('No blogs found.'));
//                   //     } else {
//                   //       return ListView.builder(
//                   //         shrinkWrap: true,
//                   //         physics: NeverScrollableScrollPhysics(),
//                   //         itemCount: snapshot.data!.docs.length,
//                   //         itemBuilder: (context, index) {
//                   //           return Column(
//                   //             children: [
//                   //               const SizedBox(height: 20),
//                   //               BlogCard(
//                   //                 snap: snapshot.data!.docs[index],
//                   //               ),
//                   //               (index == snapshot.data!.docs.length - 1)
//                   //                   ? const SizedBox(height: 20)
//                   //                   : Container(),
//                   //             ],
//                   //           );
//                   //         },
//                   //       );
//                   //     }
//                   //   },
//                   // ),
//                 ],
//               ),
//             ),
//           );
//   }
// }

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
                // User Profile Picture
                CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(userData["photourl"]),
                  radius: 70,
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
                    // Text(
                    //   "- $publishedBlogsLen",
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 20,
                    //   ),
                    // ),
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

                    // setState(() {
                    //   publishedBlogsLen = snapshot.data!.docs.length;
                    // });

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final blogDoc = snapshot.data!.docs[index];
                        if (blogDoc.exists) {
                          return Column(
                            children: [
                              // Row(
                              //   children: [
                              //     const Padding(
                              //       padding: EdgeInsets.only(left: 10),
                              //       child: Text(
                              //         "Blogs",
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 20,
                              //         ),
                              //       ),
                              //     ),
                              //     const SizedBox(width: 4),
                              //     Text(
                              //       "- ${snapshot.data!.docs.length}",
                              //       style: const TextStyle(
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 20,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Divider(
                              //   thickness: 2,
                              //   color: Colors.grey[400],
                              //   indent: 10,
                              //   endIndent:
                              //       MediaQuery.of(context).size.width * 0.5,
                              // ),
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

                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection("blogs")
                //       .where("uid", isEqualTo: widget.uid)
                //       .orderBy("datepublished", descending: true)
                //       .snapshots(),
                //   builder: (context,
                //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                //           snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }

                //     return ListView.builder(
                //       shrinkWrap: true,
                //       physics: const NeverScrollableScrollPhysics(),
                //       itemCount: snapshot.data!.docs.length,
                //       itemBuilder: (context, index) {
                //         return Column(
                //           children: [
                //             const SizedBox(height: 20),
                //             BlogCard(
                //               snap: snapshot.data!.docs[index],
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
    );
  }
}
