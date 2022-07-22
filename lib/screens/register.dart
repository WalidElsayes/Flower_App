import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowerapp/shared/constants/colors.dart';
import 'package:flowerapp/shared/constants/decoration_textfield.dart';
import 'package:flowerapp/shared/snakbar.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final usernameController = TextEditingController();

  bool hasMin8Characters = false;
  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;

  onPasswordChanged(String password) {
    hasMin8Characters = false;
    hasUppercase = false;
    hasDigits = false;
    hasLowercase = false;

    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        hasMin8Characters = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        hasDigits = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }
    });
  }

  bool isLoading = false;
  bool isInvisible = true;

  register() async {
    // show 'Loading' on the button
    setState(() {
      isLoading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      // FireStore
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      users.doc(credential.user!.uid).set({
        'User_Name': usernameController.text,
        'Email': emailController.text,
        'Password': passController.text,
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
      } else {
        // show Error in SnackBar
        showSnackBar(context, 'ERROR - Please try again later');
      }
    } catch (e) {
      // show any Error i don't know it in SnackBar
      showSnackBar(context, e.toString());
    }
    // show 'Sign Up' on the button
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text(
          'Register',
          style: TextStyle(fontSize: 25),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: decorationTextField.copyWith(
                            hintText: 'User Name',
                            suffixIcon: const IconTheme(
                                data: IconThemeData(color: btnGreen),
                                child: Icon(Icons.person)))),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                        validator: (email) {
                          return email!.contains(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                              ? null
                              : "Enter a valid email";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: decorationTextField.copyWith(
                            hintText: 'Email Adress',
                            suffixIcon: const IconTheme(
                                data: IconThemeData(color: btnGreen),
                                child: Icon(Icons.email)))),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                        onChanged: (password) {
                          onPasswordChanged(password);
                        },
                        validator: (password) {
                          return password!.length < 8
                              ? "Enter at least 8 characters"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passController,
                        keyboardType: TextInputType.text,
                        obscureText: isInvisible,
                        decoration: decorationTextField.copyWith(
                            hintText: 'Password',
                            suffixIcon: IconTheme(
                                data: const IconThemeData(color: btnGreen),
                                child: IconButton(
                                  icon: isInvisible
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      isInvisible = !isInvisible;
                                    });
                                  },
                                )))),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 11),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            shape: BoxShape.circle,
                            color:
                                hasMin8Characters ? Colors.green : Colors.white,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const Text("At least 8 charachters"),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 11),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            shape: BoxShape.circle,
                            color: hasDigits ? Colors.green : Colors.white,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const Text("At least 1 number"),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 11),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            shape: BoxShape.circle,
                            color: hasUppercase ? Colors.green : Colors.white,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const Text("Has Uppercase"),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 11),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            shape: BoxShape.circle,
                            color: hasLowercase ? Colors.green : Colors.white,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const Text("Has Lowercase"),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            await register();
                          } else {
                            showSnackBar(context,
                                'Error : Please enter a valid email & pass');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: btnGreen,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Register',
                                style: TextStyle(fontSize: 19))),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account ?',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                                fontSize: 18,
                                color: btnGreen,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
