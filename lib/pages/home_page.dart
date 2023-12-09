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
