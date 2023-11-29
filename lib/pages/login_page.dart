import 'package:ezblog/pages/bottom_navigation.dart';
import 'package:ezblog/pages/signup_page.dart';
import 'package:ezblog/resources/auth_methods.dart';
import 'package:ezblog/utils/utils.dart';
import 'package:ezblog/widgets/my_text_field.dart';
import 'package:ezblog/widgets/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  // final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String ret = await AuthMethods().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    if (ret != "success") {
      showSnackBar(ret, context);
    } else {
      showSnackBar("Login Succesful!", context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );

      print("Login Succesfull!");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void NavigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  void NavigateToHomePage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BottomNavigation()));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    // userNameController.dispose();
    passwordController.dispose();
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
                const SizedBox(height: 64),
                Image.asset('assets/images/ez_blog_logo.png', scale: 1.2),

                // Email Input
                const SizedBox(height: 64),
                MyTextField(
                    textController: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress),

                // Username Input
                // const SizedBox(height: 20),
                // MyTextField(
                //   textController: userNameController,
                //   hintText: "Username",
                //   keyboardType: TextInputType.name,
                // ),

                // Password Input
                const SizedBox(height: 20),
                MyTextField(
                    textController: passwordController,
                    hintText: "Password",
                    obscure: true,
                    keyboardType: TextInputType.text),

                // TODO: Change it to password type

                // forgot password?
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Login Button
                const SizedBox(height: 30),
                InkWell(
                  onTap: loginUser,
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
                            "Log In",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                // ----- Or Log In With -----
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
                          'Or Log In with',
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
                      child: const Text("New User? "),
                    ),
                    GestureDetector(
                      onTap: NavigateToSignUp,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Sign Up",
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
