class Item {
  String name;
  String imgPath;
  double price;
  String location;
  String details;

  Item({
    required this.name,
    required this.imgPath,
    required this.price,
    this.location = 'Main Branch',
    this.details =
        'A flower, sometimes known as a bloom or blossom, is the reproductive structure found in flowering plants (plants of the division Angiospermae). The biological function of a flower is to facilitate reproduction, usually by providing a mechanism for the union of sperm with eggs. Flowers may facilitate outcrossing (fusion of sperm and eggs from different individuals in a population) resulting from cross-pollination or allow selfing (fusion of sperm and egg from the same flower) when self-pollination occurs.',
  });
}

final List items = [
  Item(name : 'Flower 1',imgPath: '1.webp', price: 11.00, location: 'Elsayes Shop'),
  Item(name : 'Flower 2',imgPath: '2.webp', price: 15.20),
  Item(name : 'Flower 3',imgPath: '3.webp', price: 30.50),
  Item(name : 'Flower 4',imgPath: '4.webp', price: 17.22),
  Item(name : 'Flower 5',imgPath: '5.webp', price: 19.42),
  Item(name : 'Flower 6',imgPath: '6.webp', price: 45.50),
  Item(name : 'Flower 7',imgPath: '7.webp', price: 35.30),
  Item(name : 'Flower 8',imgPath: '8.webp', price: 71.12),
];
