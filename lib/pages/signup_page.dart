// import 'dart:js_interop';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezblog/pages/login_page.dart';
import 'package:ezblog/resources/auth_methods.dart';
import 'package:ezblog/utils/utils.dart';
import 'package:ezblog/widgets/my_text_field.dart';
import 'package:ezblog/widgets/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false, _localUserExists = false, check = true;

  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
  }

  // Method to pick an image
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  // Method to pass the data fields to the authmethods and create a new account
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // get feedback from the authmethods' signup function
      String retMessage = await AuthMethods().SingUp(
        email: emailController.text.trim(),
        userName: userNameController.text.trim(),
        password: passwordController.text.trim(),
        file: _image!,
      );

      if (retMessage != "success") {
        showSnackBar(retMessage, context);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        showSnackBar("New Account Created Succesfully!", context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Navigate to the login page
  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  // Method to check if username exists
  Future<bool> checkIfUsernameExists(String name) async {
    try {
      // Get the required snapshot from firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("userName", isEqualTo: name)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username: $e');
      showSnackBar(e.toString(), context);
      return false;
    }
  }

  // Widget to display username availability status
  Widget buildUsernameAvailability() {
    String temp = userNameController.text.trim();

    if (userNameController.text.isEmpty) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<bool>(
      future: checkIfUsernameExists(userNameController.text.trim()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error checking username');
        } else if (snapshot.data == true) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "'${temp}' already exists",
                style: const TextStyle(color: Colors.red),
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "'${temp}' is available",
                style: const TextStyle(color: Colors.green),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(child: Container(), flex: 2),

                // Logo
                // const SizedBox(height: 10),
                // Image.asset('assets/images/ez_blog_logo.png', scale: 1.2),

                // Welcome Text
                const SizedBox(height: 20),
                const Text(
                  "Welcome to EzBlog!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                // Avatar
                const SizedBox(height: 64),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://i.pinimg.com/custom_covers/222x/85498161615209203_1636332751.jpg"),
                          ),
                    Positioned(
                      left: 80,
                      bottom: -10,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),

                // Email Input
                const SizedBox(height: 64),
                MyTextField(
                    textController: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress),

                // Username Input Form
                const SizedBox(height: 20),
                TextFormField(
                  controller: userNameController,
                  onChanged: (String str) {
                    setState(() {
                      // check = true;
                      // txt = str;
                      // _localUserExists = await checkIfUsernameExists(txt);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "UserName",
                    focusedBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    border: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    filled: true,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),

                // Username availability display
                // check ? buildUsernameAvailability() : Container(),
                buildUsernameAvailability(),

                // Password Input
                const SizedBox(height: 20),
                MyTextField(
                    textController: passwordController,
                    hintText: "Password",
                    obscure: true,
                    keyboardType: TextInputType.text),

                // Sign Up Button
                const SizedBox(height: 30),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Colors.blue,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                // ----- Or Sign Up With -----
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or Sing Up with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                // google + facebook sign in buttons
                const SizedBox(height: 32),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'assets/images/google.png'),

                    SizedBox(width: 25),

                    // facebook button
                    SquareTile(imagePath: 'assets/images/facebook.png'),
                  ],
                ),

                // Flexible(child: Container(), flex: 2),

                // Sign Up Text
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Have an Account? "),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
