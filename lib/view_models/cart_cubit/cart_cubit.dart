import 'package:e_commerce_app/services/auth_services.dart';
import 'package:e_commerce_app/services/cart_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  int quantity = 1;

  final cartServices = CartServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getCartItems() async {
    emit(CartLoading());
    try {
      final currentUser = authServices.currentUser();
      final cartItems = await cartServices.fetchCartItems(currentUser!.uid);

      emit(CartLoaded(cartItems, _subtotal(cartItems)));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // داخل cart_cubit.dart

  Future<void> decrementCounter(AddToCartModel cartItem, [int? initialValue]) async {
    // إحضار الكمية الحالية الخاصة بهذا المنتج تحديداً
    int currentQuantity = initialValue ?? cartItem.quantity;

    // يمنع التخفيض إذا كانت الكمية 1 أو أقل
    if (currentQuantity <= 1) return;

    currentQuantity--;

    try {
      final updatedCartItem = cartItem.copyWith(quantity: currentQuantity);
      final currentUser = authServices.currentUser();
      await cartServices.setCartItem(currentUser!.uid, updatedCartItem);

      // إعادة جلب القائمة وتحديث الـ State الكلية للسلة
      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      final newSubtotal = _subtotal(cartItems);

      emit(CartLoaded(cartItems, newSubtotal));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> incrementCounter(AddToCartModel cartItem, [int? initialValue]) async {
    int currentQuantity = initialValue ?? cartItem.quantity;
    currentQuantity++;

    try {
      final updatedCartItem = cartItem.copyWith(quantity: currentQuantity);
      final currentUser = authServices.currentUser();
      await cartServices.setCartItem(currentUser!.uid, updatedCartItem);

      final cartItems = await cartServices.fetchCartItems(currentUser.uid);
      final newSubtotal = _subtotal(cartItems);

      emit(CartLoaded(cartItems, newSubtotal));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  double _subtotal(List<AddToCartModel> cartItems) => cartItems.fold<double>(
    0,
    (previousValue, item) => previousValue + (item.product.price * item.quantity),
  );
}
