import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowerapp/shared/constants/decoration_textfield.dart';
import 'package:flutter/material.dart';

class GetDataFromFireStore extends StatefulWidget {
  final String documentId;

  const GetDataFromFireStore({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<GetDataFromFireStore> createState() => _GetDataFromFireStoreState();
}

class _GetDataFromFireStoreState extends State<GetDataFromFireStore> {
  final credential = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final dialogUsernameController = TextEditingController();

  myDialog(Map data, dynamic myKey) {
    var userName = data['User_Name'];
    

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Container(
            padding: const EdgeInsets.all(22),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: dialogUsernameController,
                    maxLength: 20,
                    decoration: decorationTextField.copyWith(
                        hintText:
                            "${userName == null ? 'Enter your name' : data[myKey]}")),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          users.doc(credential!.uid).update(
                              {'User_Name': dialogUsernameController.text});

                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(177, 3, 143, 26)),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(177, 3, 143, 26)),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          var userName = data['User_Name'];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Name : ${userName == null ? 'Enter your name' : data['User_Name']}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          users
                              .doc(credential!.uid)
                              .update({'User_Name': FieldValue.delete()});
                        });
                      },
                      icon: const Icon(Icons.delete)),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'User_Name');
                      },
                      icon: const Icon(Icons.edit)),
                ],
              )
            ],
          );
        }

        return const Text("loading");
      },
    );
  }
}
