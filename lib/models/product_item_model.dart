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
