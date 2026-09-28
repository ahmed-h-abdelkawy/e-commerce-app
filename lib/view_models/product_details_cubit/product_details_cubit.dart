import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/product_item_model.dart';
import 'package:e_commerce_app/services/auth_services.dart';
import 'package:e_commerce_app/services/product_details_services.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  ProductSize? selectedSize;
  int quantity = 1;

  final productDetailsServices = ProductDetailsServicesImpl();
  final authServices = AuthServicesImpl();

  void getProductDetails(String id) async {
    emit(ProductDetailsLoading());
    try {
      final currentUser = authServices.currentUser();
      final selectedProduct = await productDetailsServices.fetchProductDetails(id);

      // نجيب المفضلة عشان نعرف المنتج ده جواها ولا لأ
      final favoriteProducts = await productDetailsServices.fetchFavoriteProducts(
        currentUser!.uid,
      );
      final isFavorite = favoriteProducts.any((item) => item.id == id);

      // نعمل نسخة جديدة من المنتج بالقيمة الصحيحة للـ isFavorite
      final finalProduct = selectedProduct.copyWith(isFavorite: isFavorite);

      emit(ProductDetailsLoaded(product: finalProduct));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  Future<void> setFavorite(ProductItemModel product) async {
    emit(SetFavoriteLoading(productId: product.id));
    try {
      final currentUser = authServices.currentUser();
      final favoriteProduct = await productDetailsServices.fetchFavoriteProducts(
        currentUser!.uid,
      );
      final isFavorite = favoriteProduct.any((item) => item.id == product.id);

      if (isFavorite) {
        await productDetailsServices.removeFavoriteProduct(
          userId: currentUser.uid,
          productId: product.id,
        );
      } else {
        await productDetailsServices.addFavoriteProduct(
          userId: currentUser.uid,
          product: product,
        );
      }
      // بنبعت عكس الحالة لأننا غيرناها خلاص بنجاح
      emit(SetFavoriteSuccess(isFavorite: !isFavorite, productId: product.id));
    } catch (e) {
      emit(SetFavoriteError(e.toString(), product.id));
    }
  }

  void incrementCounter(String productId) {
    quantity++;
    emit(QuantityCounterLoaded(value: quantity, productId: productId));
  }

  void decrementCounter(String productId) {
    quantity--;
    emit(QuantityCounterLoaded(value: quantity, productId: productId));
  }

  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }

  Future<void> addToCart(String productId) async {
    emit(ProductAddingToCart());
    try {
      final selectedProduct = await productDetailsServices.fetchProductDetails(
        productId,
      );
      final currentUser = authServices.currentUser();
      final cartItem = AddToCartModel(
        id: DateTime.now().toIso8601String(),
        product: selectedProduct,
        size: selectedSize!,
        quantity: quantity,
      );
      await productDetailsServices.addToCart(cartItem, currentUser!.uid);
      emit(ProductAddedToCart(productId: productId));
    } catch (e) {
      emit(ProductAddToCartError(e.toString()));
    }
  }
}
