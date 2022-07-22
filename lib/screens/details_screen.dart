import 'package:flowerapp/shared/AppBar_Cart.dart';
import 'package:flowerapp/model/item.dart';
import 'package:flowerapp/shared/constants/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Details extends StatefulWidget {
  Item product;

  Details({required this.product, Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isShowMore = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text(
          'Details',
          style: TextStyle(fontSize: 25),
        ),
        actions: const [
          AppBarCart(),
        ],
      ),
      body: Column(children: [
        Image.asset('assets/images/${widget.product.imgPath}'),
        const SizedBox(
          height: 11,
        ),
        Text(
          '\$ ${widget.product.price}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 18,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 10),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 129, 129),
                              borderRadius: BorderRadius.circular(4)),
                          child: const Text(
                            'New',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        const Icon(Icons.star,
                            size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                        const Icon(Icons.star,
                            size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                        const Icon(Icons.star,
                            size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                        const Icon(Icons.star,
                            size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                        const Icon(Icons.star,
                            size: 26, color: Color.fromARGB(255, 255, 191, 0)),
                      ],
                    ),
                    Row(children: [
                      const Icon(Icons.edit_location,
                          size: 26, color: Color.fromARGB(168, 3, 65, 27)),
                      Text(
                        widget.product.location,
                        style: const TextStyle(fontSize: 19),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Details :',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  widget.product.details,
                  style: const TextStyle(fontSize: 20),
                  maxLines: isShowMore ? 3 : null,
                  overflow: TextOverflow.fade,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        isShowMore = !isShowMore;
                      });
                    },
                    child: Text(
                      isShowMore ? 'Show more' : 'Show less',
                      style: const TextStyle(fontSize: 18, color: appbarGreen),
                    )),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
