import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/utils/api_pathes.dart';

abstract class CartServices {
  Future<List<AddToCartModel>> fetchCartItems(String userId);
  Future<void> setCartItem(String userId, AddToCartModel cartItem);
}

class CartServicesImpl implements CartServices {
  final fireStoreServices = FirestoreServices.instance;

  @override
  Future<List<AddToCartModel>> fetchCartItems(String userId) async =>
      await fireStoreServices.getCollection(
        path: ApiPathes.cartItems(userId),
        builder: (data, documentId) => AddToCartModel.fromMap(data),
      );

  @override
  Future<void> setCartItem(String userId, AddToCartModel cartItem) async =>
      await fireStoreServices.setData(
        path: ApiPathes.cartItem(userId, cartItem.id),
        data: cartItem.toMap(),
      );
}
