import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flowerapp/screens/login.dart';
import 'package:flowerapp/shared/constants/colors.dart';
import 'package:flowerapp/shared/data_from_firestore.dart';
import 'package:flowerapp/shared/snakbar.dart';
import 'package:flowerapp/shared/user_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show basename;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final credential = FirebaseAuth.instance.currentUser;
//  CollectionReference users =  FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;

  File? imgPath;
  //Global variable
  String? imgName;

  uploadImage(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          // Add random numbers to imgName to make fireStorage don't replace photo that has the same imgName
          int random = Random().nextInt(999999);
          imgName = "$random$imgName";
          Navigator.pop(context);
        });
      } else {
        if (!mounted) return;
        showSnackBar(context, "NO image selected");
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, "Error => $e");
    }
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.camera);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage(ImageSource.gallery);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  savePhoto() async {
    try {
      // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref('images/$imgName');
      await storageRef.putFile(imgPath!);
// Get img url
      String url = await storageRef.getDownloadURL();

// // Store img url in firestore[database]
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      //  users.doc(credential!.uid).set({"imgURL": url,});
//====OR====
      users.doc(credential!.uid).update({
        "imgURL": url,
      });
      if (!mounted) return;

      showSnackBar(context, "Image added successfully");
    } catch (e) {
      showSnackBar(context, "NO image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            label: const Text(
              "logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: appbarGreen,
        title: const Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    imgPath == null
                        ? const ImgUser()
                        : ClipOval(
                            child: Image.file(
                              imgPath!,
                              width: 145,
                              height: 145,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Positioned(
                      left: 95,
                      bottom: -10,
                      child: IconButton(
                        onPressed: () async {
                          await showmodel();
                          savePhoto();
                        },
                        icon: const Icon(Icons.add_a_photo),
                        color: const Color.fromARGB(255, 94, 115, 128),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 33,
              ),
              Center(
                  child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(177, 3, 143, 26),
                    borderRadius: BorderRadius.circular(11)),
                child: const Text(
                  "Your Information",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  GetDataFromFireStore(documentId: credential!.uid),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Email : ${credential!.email}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Created date : ${DateFormat("MMMM d, y").format(credential!.metadata.creationTime!)}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Last Signed In : ${DateFormat("MMMM d, y").format(credential!.metadata.lastSignInTime!)}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11)),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "Are you sure to delete user",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                177, 3, 143, 26)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                credential!.delete();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Login()));
                                                //  users.doc(credential!.uid).delete();
                                              },
                                              child: const Text(
                                                "Ok",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                        177, 3, 143, 26)),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                        177, 3, 143, 26)),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Delete User",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(177, 3, 143, 26)),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
