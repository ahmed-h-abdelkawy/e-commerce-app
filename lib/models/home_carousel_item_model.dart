class HomeCarouselItemModel {
  final String id;
  final String imgUrl;

  HomeCarouselItemModel({required this.id, required this.imgUrl});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'imgUrl': imgUrl};
  }

  factory HomeCarouselItemModel.fromMap(Map<String, dynamic> map) {
    return HomeCarouselItemModel(id: map['id'] ?? '', imgUrl: map['imgUrl'] ?? '');
  }
}
