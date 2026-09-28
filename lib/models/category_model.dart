class CategoryModel {
  final String id;
  final String name;
  final int productsCount;
  final String imgPath;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
    required this.imgPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'productsCount': productsCount,
      'imgPath': imgPath,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      productsCount: int.tryParse(map['productsCount'].toString()) ?? 0,
      imgPath: map['imgPath'] ?? '',
    );
  }
}

// List<CategoryModel> dummyCategories = [
//   CategoryModel(
//     id: '1',
//     name: 'New Arrivals',
//     productsCount: 208,
//     imgPath: 'assets/images/new_arrivals.jpg',
//   ),
//   CategoryModel(
//     id: '2',
//     name: 'Clothes',
//     productsCount: 358,
//     imgPath: 'assets/images/clothes.jpg',
//   ),
//   CategoryModel(
//     id: '3',
//     name: 'Bags',
//     productsCount: 160,
//     imgPath: 'assets/images/bags.jpg',
//   ),
//   CategoryModel(
//     id: '4',
//     name: 'Shoes',
//     productsCount: 230,
//     imgPath: 'assets/images/shoese.jpg',
//   ),
//   CategoryModel(
//     id: '5',
//     name: 'Electronics',
//     productsCount: 101,
//     imgPath: 'assets/images/electronics.jpg',
//   ),
//   CategoryModel(
//     id: '6',
//     name: 'Groceries',
//     productsCount: 86,
//     imgPath: 'assets/images/Groceries.jpeg',
//   ),
// ];
