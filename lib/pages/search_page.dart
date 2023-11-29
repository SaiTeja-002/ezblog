import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezblog/pages/detailed_blog_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  bool _showBlogs = false;
  String searchText = "";

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    clearSearchField() {
      setState(() {
        _searchController.text = "";
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextFormField(
            textAlign: TextAlign.left,
            controller: _searchController,
            decoration: const InputDecoration(labelText: "Search here"),
            onFieldSubmitted: (String str) {
              print(str);
              setState(() {
                _showBlogs = true;
                searchText = str;
              });
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                clearSearchField();
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: _searchController.text.isEmpty
            ? const Center(
                child: Text("Search something to display!"),
              )
            : _showBlogs
                ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("blogs")
                        .orderBy("title")
                        .startAt([_searchController.text]).endAt(
                            ['${_searchController.text}\uf8ff']).get(),

                    // .where("title", isGreaterThanOrEqualTo: searchText)
                    // .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if ((snapshot.data! as dynamic).docs.length == 0) {
                        return const Center(
                            child: Text("No such blogs found!"));
                      }

                      return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlogDetailPage(
                                    snap: (snapshot.data! as dynamic)
                                        .docs[index]),
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ["posturl"]),
                              ),
                              title: Text((snapshot.data! as dynamic)
                                  .docs[index]["title"]),
                            ),
                          );
                        },
                      );
                    })
                : Container(
                    child: Text("Type something to search"),
                  ));
  }
}
