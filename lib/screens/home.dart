import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowerapp/screens/checkout.dart';
import 'package:flowerapp/screens/login.dart';
import 'package:flowerapp/screens/profile.dart';
import 'package:flowerapp/shared/AppBar_Cart.dart';
import 'package:flowerapp/model/item.dart';
import 'package:flowerapp/provider/cart.dart';
import 'package:flowerapp/screens/details_screen.dart';
import 'package:flowerapp/shared/constants/colors.dart';
import 'package:flowerapp/shared/user_image.dart';
import 'package:flowerapp/shared/user_name_to_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      drawer: Drawer(
        width: 285,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  // currentAccountPictureSize: const Size.square(99),
                  currentAccountPicture: user.photoURL != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL!))
                      : const ImgUser(),
                  // backgroundImage: NetworkImage(user.photoURL!)),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/test.jpg'),
                        fit: BoxFit.cover),
                  ),
                  accountName: user.displayName != null
                      ? Text(
                          user.displayName!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        )
                      : GetUserName(documentId: user.uid),

                  // user.displayName!,
                  // style: const TextStyle(
                  //     color: Color.fromARGB(255, 255, 255, 255)),
                  // ),
                  accountEmail: Text(
                    // ('Walidelsayes1@gmail.com'),

                    user.email!,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                ListTile(
                    title: const Text("Home"),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Home())));
                    }),
                ListTile(
                    title: const Text("My products"),
                    leading: const Icon(Icons.add_shopping_cart),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const CheckOut())));
                    }),
                ListTile(
                    title: const Text("Profile info"),
                    leading: const Icon(Icons.help_center),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) => const Profile())));
                    }),
                ListTile(
                    title: const Text("About"),
                    leading: const Icon(Icons.help_center),
                    onTap: () {}),
                ListTile(
                    title: const Text("Logout"),
                    leading: const Icon(Icons.exit_to_app),
                    onTap: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                      await FirebaseAuth.instance.signOut();
                    }),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text("Developed by Waid Elsayes © 2022",
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 25),
        ),
        actions: const [
          AppBarCart(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 22.0),
        child: GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 33,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              Details(product: items[index]))));
                },
                child: GridTile(
                  child: Stack(
                    children: [
                      Positioned(
                        top: -3,
                        bottom: -9,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: Image.asset(
                                'assets/images/${items[index].imgPath}')),
                      ),
                      Positioned(
                        top: 96,
                        right: 28,
                        bottom: -5,
                        left: 28,
                        child: Container(
                          padding: const EdgeInsets.only(left: 5.0),
                          color: const Color.fromARGB(133, 62, 94, 70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$ ${items[index].price}",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Consumer<Cart>(builder: (context, cart, child) {
                                return IconButton(
                                    color:
                                        const Color.fromARGB(255, 62, 94, 70),
                                    onPressed: () {
                                      cart.add(items[index]);
                                    },
                                    icon: const Icon(Icons.add));
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
