import 'package:e_commerce_app/models/product_item_model.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/utils/api_pathes.dart';

abstract class FavoriteServices {
  Future<void> addFavorite(String userId, ProductItemModel product);
  Future<void> removeFavorite(String userId, String productId);
  Future<List<ProductItemModel>> getFavorites(String userId);
}

class FavoriteServicesImpl implements FavoriteServices {
  final fireStoreServices = FirestoreServices.instance;

  @override
  Future<void> addFavorite(String userId, ProductItemModel product) async =>
      await fireStoreServices.setData(
        path: ApiPathes.favoriteProduct(userId, product.id),
        data: product.toMap(),
      );

  @override
  Future<void> removeFavorite(String userId, String productId) async =>
      await fireStoreServices.deleteData(
        path: ApiPathes.favoriteProduct(userId, productId),
      );

  @override
  Future<List<ProductItemModel>> getFavorites(String userId) async =>
      await fireStoreServices.getCollection(
        path: ApiPathes.favoriteProducts(userId),
        builder: (data, documentId) => ProductItemModel.fromMap(data),
      );
}
