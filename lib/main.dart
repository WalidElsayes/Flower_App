import 'package:flowerapp/provider/cart.dart';
import 'package:flowerapp/provider/google_signin.dart';
import 'package:flowerapp/screens/home.dart';
import 'package:flowerapp/screens/login.dart';
import 'package:flowerapp/shared/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlowerApp());
}

class FlowerApp extends StatelessWidget {
  const FlowerApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          // معناه انه على حسب يعنى لو المستخدم سجل دخول قبل كظه مش كل مره يفتح التطبيق يسجل دخول
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // بشوف حالة الاتصال بين البيانات والفايربيز وبعمل دايرة بتتحرك
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                  //لو فيه مشكلة يطلعلى ايرور
                } else if (snapshot.hasError) {
                  return showSnackBar(context, "Something went wrong");
                  // لو مفيش مشكله يدخل على الهوم
                } else if (snapshot.hasData) {
                  return const Home();
                } else {
                  return const Login();
                }
              })),
    );
  }
}
