// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flowerapp/provider/cart.dart';
import 'package:flowerapp/screens/checkout.dart';

import 'package:provider/provider.dart';

class AppBarCart extends StatelessWidget {
  const AppBarCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: ((context, cart, child) {
      return Row(
        children: [
          Stack(
            children: [
              Positioned(
                right: 35,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(211, 164, 255, 193),
                  ),
                  child: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 30, right: 10),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const CheckOut())));
                },
                icon: const Icon(Icons.add_shopping_cart),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Text(
              "\$ ${cart.price.toStringAsFixed(2)} ",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      );
    }));
  }
}
