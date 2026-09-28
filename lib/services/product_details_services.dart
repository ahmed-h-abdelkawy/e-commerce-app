import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/product_item_model.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/utils/api_pathes.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> fetchProductDetails(String productId);
  Future<void> addToCart(AddToCartModel cartItem, String userId);

  Future<void> addFavoriteProduct({
    required String userId,
    required ProductItemModel product,
  });
  Future<void> removeFavoriteProduct({
    required String userId,
    required String productId,
  });
  Future<List<ProductItemModel>> fetchFavoriteProducts(String userId);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<ProductItemModel> fetchProductDetails(String productId) async {
    final selectedProduct = await firestoreServices.getDocument<ProductItemModel>(
      path: ApiPathes.product(productId),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
    return selectedProduct;
  }

  @override
  Future<void> addToCart(AddToCartModel cartItem, String userId) async =>
      await firestoreServices.setData(
        path: ApiPathes.cartItem(userId, cartItem.id),
        data: cartItem.toMap(),
      );

  @override
  Future<void> addFavoriteProduct({
    required String userId,
    required ProductItemModel product,
  }) async => await firestoreServices.setData(
    path: ApiPathes.favoriteProduct(userId, product.id),
    data: product.toMap(),
  );

  @override
  Future<void> removeFavoriteProduct({
    required String userId,
    required String productId,
  }) async => await firestoreServices.deleteData(
    path: ApiPathes.favoriteProduct(userId, productId),
  );

  @override
  Future<List<ProductItemModel>> fetchFavoriteProducts(String userId) async {
    final result = await firestoreServices.getCollection<ProductItemModel>(
      path: ApiPathes.favoriteProducts(userId),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
    return result;
  }
}
