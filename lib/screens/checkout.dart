import 'package:flowerapp/provider/cart.dart';
import 'package:flowerapp/shared/AppBar_Cart.dart';
import 'package:flowerapp/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text(
          'CheckOut',
          style: TextStyle(fontSize: 25),
        ),
        actions: const [
          AppBarCart(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<Cart>(builder: ((context, cart, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: ListTile(
                          leading: Image.asset(
                              'assets/images/${cart.selectedProduct[index].imgPath}'),
                          title: Text('${cart.selectedProduct[index].name}'),
                          subtitle: Text(
                              '\$ ${cart.selectedProduct[index].price} - ${cart.selectedProduct[index].location}'),
                          trailing: IconButton(
                              onPressed: () {
                                cart.delete(cart.selectedProduct[index]);
                              },
                              icon: const Icon(Icons.remove)),
                        ),
                      );
                    })),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(primary: btnPink),
                child: Text('Pay \$ ${cart.price.toStringAsFixed(2)}'),
              )
            ],
          );
        })),
      ),
    );
  }
}
