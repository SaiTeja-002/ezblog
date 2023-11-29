// import 'package:ezblog/pages/blog_card.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Scaffold(
//         // backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           elevation: 0.0,
//           title: const Text(
//             "EzBlog",
//             style: TextStyle(color: Colors.black),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//         ),
//         // body: Column(
//         //   children: [BlogCard(), BlogCard(), BlogCard()],
//         // ),
//         body: BlogCard(),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:ezblog/pages/blog_card.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blog Cards'),
//       ),
//       body: ListView(
//         // Use ListView.builder if you have a dynamic list of cards
//         // Example:
//         // itemCount: blogPosts.length,
//         // itemBuilder: (context, index) {
//         //   return BlogCard(blogPost: blogPosts[index]);
//         // },
//         children: <Widget>[
//           BlogCard(),
//           BlogCard(),
//           BlogCard(),
//           BlogCard(),
//           BlogCard(),
//           BlogCard(),
//           // Add more BlogCard widgets as needed
//         ],
//       ),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // Sample dynamic list of blog posts
//   // List<BlogPost> blogPosts = [
//   //   BlogPost("User1", "Content1"),
//   //   BlogPost("User2", "Content2"),
//   //   BlogPost("User3", "Content3"),
//   //   BlogPost("User2", "Content2"),
//   //   BlogPost("User3", "Content3"),
//   //   // Add more blog posts as needed
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     List<BlogCard> blogPostCards = [
//       BlogCard(),
//       BlogCard(),
//       BlogCard(),
//       BlogCard(),
//       BlogCard(),
//       BlogCard(),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('EzBlog'),
//         backgroundColor: Colors.grey[400],
//         automaticallyImplyLeading: false,
//       ),

//       // Blogs Listview Builder
//       body: ListView.builder(
//         itemCount: blogPostCards.length,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               SizedBox(height: 20),
//               BlogCard(),
//               (index == blogPostCards.length - 1)
//                   ? SizedBox(height: 20)
//                   : Container(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class BlogPost {
//   final String userName;
//   final String content;

//   BlogPost(this.userName, this.content);
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ezblog/pages/blog_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EzBlog'),
        backgroundColor: Colors.grey[400],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("blogs")
            .orderBy("datepublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  BlogCard(
                    snap: snapshot.data!.docs[index],
                  ),
                  (index == snapshot.data!.docs.length - 1)
                      ? SizedBox(height: 20)
                      : Container(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
