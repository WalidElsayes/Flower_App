import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowerapp/shared/constants/colors.dart';
import 'package:flowerapp/shared/constants/decoration_textfield.dart';
import 'package:flowerapp/shared/snakbar.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailController = TextEditingController();

  resetPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      if (!mounted) return;

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else {
        showSnackBar(context, 'ERROR : ${e.code}');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text(
          'Reset Password',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                                Text("Enter your email to reset your password",
                    style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 33,
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
                ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        await resetPassword();
                      } else {
                        showSnackBar(
                            context, 'Error : Please enter a valid email');
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
                        : const Text('Reset password',
                            style: TextStyle(fontSize: 19))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flowerapp/screens/login.dart';
// import 'package:flowerapp/shared/constants/colors.dart';
// import 'package:flowerapp/shared/constants/decoration_textfield.dart';
// import 'package:flowerapp/shared/snakbar.dart';
// import 'package:flutter/material.dart';

// class ResetPassword extends StatefulWidget {
//   ResetPassword({Key? key}) : super(key: key);

//   @override
//   State<ResetPassword> createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ResetPassword> {
//   final emailController = TextEditingController();
//   bool isLoading = false;
//   final _formKey = GlobalKey<FormState>();

//   resetPassword() async {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Colors.white,
//             ),
//           );
//         });

//     try {
//       await FirebaseAuth.instance
//           .sendPasswordResetEmail(email: emailController.text);
//       if (!mounted) return;
//       if (!mounted) return;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => Login()));
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, "ERROR :  ${e.code} ");
//     }

// // Stop indicator

  
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     emailController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Reset Password"),
//         elevation: 0,
//         backgroundColor: appbarGreen,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(33.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Enter your email to rest your password.",
//                     style: TextStyle(fontSize: 18)),
//                 SizedBox(
//                   height: 33,
//                 ),
//                 TextFormField(
//                     // we return "null" when something is valid
//                     validator: (email) {
//                       return email!.contains(RegExp(
//                               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
//                           ? null
//                           : "Enter a valid email";
//                     },
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     controller: emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     obscureText: false,
//                     decoration: decorationTextField.copyWith(
//                         hintText: "Enter Your Email : ",
//                         suffixIcon: Icon(Icons.email))),
//                 const SizedBox(
//                   height: 33,
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       resetPassword();
//                     } else {
//                       showSnackBar(context, "ERROR");
//                     }
//                   },
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(btnGreen),
//                     padding: MaterialStateProperty.all(EdgeInsets.all(12)),
//                     shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8))),
//                   ),
//                   child: isLoading
//                       ? CircularProgressIndicator(
//                           color: Colors.white,
//                         )
//                       : Text(
//                           "Reset Password",
//                           style: TextStyle(fontSize: 19),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
