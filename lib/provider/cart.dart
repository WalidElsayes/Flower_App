import 'package:flowerapp/model/item.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  List selectedProduct = [];
  double price = 0;

  add(Item product) {
    selectedProduct.add(product);
    price += product.price;
    notifyListeners();
  }

  delete(prouct) {
    selectedProduct.remove(prouct);
    price -= prouct.price;
    notifyListeners();
  }

  int get itemCount {
    return selectedProduct.length;
  }
}
