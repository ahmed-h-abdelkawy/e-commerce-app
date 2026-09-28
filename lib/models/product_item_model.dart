enum ProductSize {
  S,
  M,
  L,
  XL;

  static ProductSize fromString(String size) {
    switch (size.toUpperCase()) {
      case 'S':
        return ProductSize.S;
      case 'M':
        return ProductSize.M;
      case 'L':
        return ProductSize.L;
      case 'XL':
        return ProductSize.XL;
      default:
        return ProductSize.S;
    }
  }
}

class ProductItemModel {
  final String id;
  final String name;
  final String imgUrl;
  final String description;
  final double price;
  final bool isFavorite;
  final String category;
  final double averageRate;

  ProductItemModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    this.description =
        'Lorem ipsum dolor sit amet. Est tempore veniam aut harum autem 33 quisquam veritatis in laudantium alias eum neque doloribus aut vitae aliquid sit sunt facere. Ex neque vitae eum ipsum aperiam sed sint repellendus qui tempore nihil sit veritatis aspernatur a officia distinctio. Non blanditiis amet ea consequatur odio eos earum quia sit nihil corporis 33 repellat natus ut laboriosam tenetur qui ipsa quia.',
    required this.price,
    this.isFavorite = false,
    required this.category,
    this.averageRate = 4.5,
  });

  ProductItemModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    String? description,
    double? price,
    bool? isFavorite,
    String? category,
    double? averageRate,
    int? quantity,
    ProductSize? size,
  }) {
    return ProductItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      description: description ?? this.description,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      averageRate: averageRate ?? this.averageRate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
      'description': description,
      'price': price,
      // 'isFavorite': isFavorite,
      'category': category,
      'averageRate': averageRate,
    };
  }

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    return ProductItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      // isFavorite: map['isFavorite'] ?? false,
      category: map['category'] ?? '',
      averageRate: map['averageRate']?.toDouble() ?? 0.0,
    );
  }
}

// List<ProductItemModel> dummyProducts = [
//   ProductItemModel(
//     id: 'K434118okA3XH70vmCgI',
//     name: 'Running Shoes',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/036/051/916/small_2x/ai-generated-a-pair-of-yellow-and-blue-running-shoes-photo.jpg',
//     price: 20,
//     category: 'Shoes',
//   ),
//   ProductItemModel(
//     id: '3p6nOiAbCwlKNZkme7t2',
//     name: 'Trousers',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/075/210/384/small_2x/beige-trousers-hanging-on-a-clothes-hanger-photo.jpg',
//     price: 30,
//     category: 'Clothes',
//   ),
//   ProductItemModel(
//     id: 'Y4xM7ukLvqRsurgioQmN',
//     name: 'HeadPhones',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/069/824/164/small_2x/white-headphones-pale-purple-minimalist-product-shot-free-photo.jpg',
//     price: 10,
//     category: 'Electronics',
//   ),
//   ProductItemModel(
//     id: 'OHncCKAImAwC9jg9XPam',
//     name: 'Pack of Potatoes',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/041/444/658/small_2x/ai-generated-fresh-organic-potatoes-in-bag-sacks-isolated-on-white-background-healthy-and-organic-food-ai-generated-transparent-with-shadow-png.png',
//     price: 10,
//     category: 'Groceries',
//   ),
//   ProductItemModel(
//     id: '7WqSYwiEbed0G05zM72u',
//     name: 'Gaming Keyboard',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/080/693/876/small/modern-mechanical-gaming-keyboard-with-orange-led-backlighting-on-black-reflective-surface-photo.jpeg',
//     price: 10,
//     category: 'Electronics',
//   ),
//   ProductItemModel(
//     id: 'NQwKrejnxOFcgAzdkoQm',
//     name: 'Pack of Apples',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/070/056/251/small_2x/a-rustic-basket-filled-with-red-apples-symbolizing-health-harvest-and-freshness-free-png.png',
//     price: 10,
//     category: 'Groceries',
//   ),
//   ProductItemModel(
//     id: 'uIVHYv1tLpiC3Jwik8b0',
//     name: 'Pack of Oranges',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/059/245/237/small_2x/sack-of-ripe-oranges-natural-and-healthy-vitamin-c-source-free-png.png',
//     price: 10,
//     category: 'Groceries',
//   ),
//   ProductItemModel(
//     id: 'BOQKlAc0GlRZXOmzcs1l',
//     name: 'Bag',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/031/588/552/small_2x/minimalist-fashion-concept-white-bag-origami-style-3d-rendering-on-white-ai-generated-photo.jpg',
//     price: 10,
//     category: 'Bags',
//   ),
//   ProductItemModel(
//     id: 'atZHZfhF5glVKKO3XCtz',
//     name: 'Pack of Mangoes',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/059/251/408/small_2x/a-rustic-wooden-box-filled-with-ripe-fresh-mangoes-set-against-a-clean-transparent-background-wooden-box-of-mangosisolated-on-transparent-background-free-png.png',
//     price: 10,
//     category: 'Groceries',
//   ),
//   ProductItemModel(
//     id: 'jXDJxAUnBWJTXrOn5V1n',
//     name: 'Sweet Shirt',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/047/242/052/small_2x/ash-sweatshirt-isolated-on-transparent-background-free-png.png',
//     price: 15,
//     category: 'Clothes',
//   ),
//   ProductItemModel(
//     id: 'PjORGdvg4dVIxnVjjhgB',
//     name: 'T-shirt',
//     imgUrl:
//         'https://static.vecteezy.com/system/resources/thumbnails/049/223/498/small_2x/black-t-shirt-ai-generative-free-png.png',
//     price: 10,
//     category: 'Clothes',
//   ),
// ];
