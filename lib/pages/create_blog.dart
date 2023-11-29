import 'package:ezblog/pages/bottom_navigation.dart';
import 'package:ezblog/resources/auth_methods.dart';
import 'package:ezblog/resources/firestore_methods.dart';
import 'package:ezblog/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:ezblog/models/user_model.dart' as UserModel;
import 'package:image_picker/image_picker.dart';

class CreateBlog extends StatefulWidget {
  final snap;
  // const CreateBlog({Key? key}) : super(key: key);
  const CreateBlog({
    super.key,
    required this.snap,
  });

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  // final User? current_user = FirebaseAuth.instance.currentUser;
  // final Future<UserModel.User> currentUser = AuthMethods().getUserDetails();
  late UserModel.User currentUser;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool newBlog = true, imgExists = false;

  // File? image;
  Uint8List? image;

  void _clearFields() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Fields'),
          content: const Text('Are you sure you want to clear all content?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _titleController.clear();
                _descriptionController.clear();
                setState(() {
                  image = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> getInitialData() async {
    UserModel.User user = await AuthMethods().getUserDetails();

    setState(() {
      currentUser = user;
      _titleController.text = widget.snap["title"];
      _descriptionController.text = widget.snap["content"];
      // image = widget.snap["posturl"];

      newBlog = widget.snap["title"] == null;

      print("Fetched the initial data - ${newBlog}");
    });
  }

  Future selectImageFromGallery() async {
    try {
      Uint8List img = await pickImage(ImageSource.gallery);

      setState(() {
        // image = imagePath as Uint8List?;
        image = img;
      });

      // XFile? result =
      //     await ImagePicker().pickImage(source: ImageSource.gallery);

      // if (result == null) {
      //   return;
      // }

      // final imagePath = File(result.path);
      // final img = await result.readAsBytes();
    } on PlatformException catch (e) {
      // SnackBar(content: )
      print("Error - $e");
    }
  }

  Future captureImage() async {
    try {
      Uint8List img = await pickImage(ImageSource.camera);

      setState(() {
        // image = imagePath as Uint8List?;
        image = img;
      });

      // XFile? result = await ImagePicker().pickImage(source: ImageSource.camera);

      // if (result == null) {
      //   return;
      // }

      // // final imagePath = File(result.path);
      // final img = await result.readAsBytes();

      // setState(() {
      //   image = img;
      // });
    } on PlatformException catch (e) {
      print("Error - $e");
    }
  }

  clearImage() {
    setState(() {
      image = null;
    });
  }

  void CreateNewBlog() async {
    if (newBlog) {
      try {
        String res = await FirestoreMethods().createBlog(
          _titleController.text,
          _descriptionController.text,
          image!,
          currentUser.uid,
          currentUser.userName,
          currentUser.photourl,
        );

        if (res == "success") {
          showSnackBar("Blog has been created!", context);

          _titleController.clear();
          _descriptionController.clear();
          setState(() {
            image = null;
          });
        } else {
          showSnackBar(
              "There was an error while creating a new blog!", context);
        }
      } catch (err) {
        showSnackBar(err.toString(), context);
      }
    } else {
      try {
        String res = await FirestoreMethods().updateBlog(widget.snap["postid"],
            _titleController.text, _descriptionController.text, image!);

        if (res == "success") {
          showSnackBar("Blog has been updated successfully!", context);

          _titleController.clear();
          _descriptionController.clear();
          setState(() {
            image = null;
            newBlog = true;
          });
        } else {
          showSnackBar("There was an error while updating the blog!", context);
        }

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomNavigation()));
      } catch (err) {
        showSnackBar(err.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new blog"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[400],
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _clearFields();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the selected image
              image != null
                  // ? Image.file(image!)
                  // ? Text(image!.toString())
                  // ? Container(
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         image: MemoryImage(image!),
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   )
                  ? SizedBox(
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.1,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(image!),
                            ),
                          ),
                        ),
                      ),
                    )
                  : newBlog
                      ? GestureDetector(
                          onTap: () {
                            selectImageFromGallery();
                          },
                          child: Center(
                            child: Container(
                              // Grey Background
                              width: screenWidth * 0.5,
                              height: screenHeight * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_upload_outlined,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "PNG",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "  |  JPG",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "  |  SVG",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: screenWidth * 0.5,
                          height: screenHeight * 0.1,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.snap["posturl"]),
                                ),
                              ),
                            ),
                          ),
                        ),

              // Pick and Capture image buttons
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Pick image button
                  // GestureDetector(
                  //   onTap: () {
                  //     pickImage();
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       color: Colors.green,
                  //     ),
                  //     // color: Colors.green,
                  //     child: const Padding(
                  //       padding: EdgeInsets.symmetric(
                  //           vertical: 10.0, horizontal: 15),
                  //       child: Text(
                  //         "Gallery",
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 17,
                  //             fontWeight: FontWeight.w500),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Gallery Button
                  MaterialButton(
                    onPressed: () {
                      selectImageFromGallery();
                    },
                    color: Colors.green,
                    child: const Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),

                  // Camera button
                  MaterialButton(
                    onPressed: () {
                      captureImage();
                    },
                    color: Colors.green,
                    child: const Text(
                      "Camera",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),

                  // Clear Button
                  MaterialButton(
                    onPressed: () {
                      clearImage();
                    },
                    child: const Text("Clear"),
                  ),
                ],
              ),

              // Title
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: TextField(
                    controller: _titleController,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      // border: OutlineInputBorder(),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // Description
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: TextField(
                    controller: _descriptionController,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 17),
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // Publish Button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Process and submit the blog content here
                  String blogTitle = _titleController.text;
                  String blogContent = _descriptionController.text.toString();

                  CreateNewBlog();
                  // You can add logic to save the blog content
                  print('Blog Title: $blogTitle');
                  print('Blog Content: $blogContent');
                },
                child: const Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
