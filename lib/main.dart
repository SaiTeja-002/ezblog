import 'package:ezblog/pages/blog_card.dart';
import 'package:ezblog/pages/bottom_navigation.dart';
import 'package:ezblog/pages/home_page.dart';
import 'package:ezblog/pages/login_page.dart';
import 'package:ezblog/pages/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData.dark(),
      // home: HomePage(),
      // home: BottomNavigation(),
      // home: HomeScreen(),
      // home: LoginScreen(),
      home: SignUpScreen(),
      // home: BlogCard(),
    );
  }
}
