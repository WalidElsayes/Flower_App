import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowerapp/provider/google_signin.dart';
import 'package:flowerapp/screens/home.dart';
import 'package:flowerapp/screens/register.dart';
import 'package:flowerapp/screens/reset_passwprd.dart';
import 'package:flowerapp/shared/constants/colors.dart';
import 'package:flowerapp/shared/constants/decoration_textfield.dart';
import 'package:flowerapp/shared/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLoading = false;
  bool isInvisible = true;

  signIn() async {
    // عملت مشاكل فى الدروس القادمه
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });

    // show 'Loading' on the button
    // setState(() {
    //   isLoading = true;
    // });

    try {
       await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password for that user.');
      } else {
        showSnackBar(context, 'ERROR : ${e.code}');
      }
    }

    // show 'Sign in' on the button
    // setState(() {
    //   isLoading = false;
    // });

    // Stop showDialog
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
      
  }

  @override
  void dispose() {
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
          'Sign in',
          style: TextStyle(fontSize: 25),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 40,
              ),
              TextFormField(
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
                  validator: (password) {
                    return password!.length < 8
                        ? "Enter at least 8 characters"
                        : null;
                  },
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
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await signIn();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: btnGreen,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child:
                  //  isLoading
                  //     ? const CircularProgressIndicator(
                  //         color: Colors.white,
                  //       )
                  //     : 
                      const Text('Sign in', style: TextStyle(fontSize: 19))),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const ResetPassword())));
                },
                child: const Text(
                  'Forgot password ?',
                  style: TextStyle(
                      fontSize: 18,
                      color: btnGreen,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Do not have an account ?',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Register())));
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 18,
                          color: btnGreen,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 17,
              ),
              SizedBox(
                width: 299,
                child: Row(
                  children: const [
                    Expanded(
                        child: Divider(
                      thickness: 0.8,
                    )),
                    Text(
                      "OR",
                      style: TextStyle(),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.8,
                    )),
                  ],
                ),
              ),
              Consumer<GoogleSignInProvider>(
                  builder: (context, googleSignInProvider, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 27),
                  child: GestureDetector(
                    onTap: () async {
                      await googleSignInProvider.googlelogin();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              // color: Colors.purple,
                              color: btnGreen,
                              width: 1)),
                      child: SvgPicture.asset(
                        "assets/icons/google.svg",
                        color: btnGreen,
                        height: 27,
                      ),
                    ),
                  ),
                );
              }),
            ]),
          ),
        ),
      ),
    );
  }
}
