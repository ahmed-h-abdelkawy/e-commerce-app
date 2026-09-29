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
