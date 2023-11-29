import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ezblog/pages/create_blog.dart';
import 'package:ezblog/pages/home_page.dart';
import 'package:ezblog/pages/profile_page.dart';
import 'package:ezblog/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    const Search(),
    const CreateBlog(snap: {}),
    ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.grey.shade400,
        // color: Colors.grey.shade200,
        // buttonBackgroundColor: Colors.grey.shade200,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined),
          Icon(Icons.search),
          Icon(Icons.add),
          Icon(Icons.person_outline),
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
    );
  }
}
