import 'package:e_commerce_app/models/location_item_model.dart';
import 'package:e_commerce_app/models/payment_card_model.dart';
import 'package:e_commerce_app/services/auth_services.dart';
import 'package:e_commerce_app/services/cart_services.dart';
import 'package:e_commerce_app/services/checkout_services.dart';
import 'package:e_commerce_app/services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final checkoutServices = CheckoutServicesImpl();
  final authServices = AuthServicesImpl();
  final locationServices = LocationServicesImpl();
  final cartServices = CartServicesImpl();

  // Future<void> getCheckoutContant() async {
  //   emit(CheckoutLoading());
  //   try {
  //     final currentUser = authServices.currentUser();
  //     final cartItems = await cartServices.fetchCartItems(currentUser!.uid);
  //     double shippingValue = 10;
  //     final subtotal = cartItems.fold(
  //       0.0,
  //       (previousValue, element) =>
  //           previousValue + (element.product.price * element.quantity),
  //     );
  //     final numOfProducts = cartItems.fold(
  //       0,
  //       ((previousValue, element) => previousValue + element.quantity),
  //     );
  //     final chosenPaymentCard = (await checkoutServices.fetchPaymentMethods(
  //       currentUser.uid,
  //       true,
  //     )).first;

  //     final chosenAddress = (await locationServices.fetchLoacations(
  //       currentUser.uid,
  //       true,
  //     )).first;

  //     emit(
  //       CheckoutLoaded(
  //         chosenPaymentCard: chosenPaymentCard,
  //         cartItems: cartItems,
  //         totalAmount: subtotal + shippingValue,
  //         subtotal: subtotal,
  //         shippingValue: shippingValue,
  //         numOfProducts: numOfProducts,
  //         chosenAddress: chosenAddress,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(CheckoutError(e.toString()));
  //   }
  // }
  Future<void> getCheckoutContant() async {
    emit(CheckoutLoading());
    try {
      final currentUser = authServices.currentUser();
      final cartItems = await cartServices.fetchCartItems(currentUser!.uid);
      double shippingValue = 10;

      final subtotal = cartItems.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element.product.price * element.quantity),
      );

      final numOfProducts = cartItems.fold(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );

      // 1. جلب قائمة وسائل الدفع بأمان
      final paymentMethods = await checkoutServices.fetchPaymentMethods(
        currentUser.uid,
        true,
      );
      final chosenPaymentCard = paymentMethods.isNotEmpty
          ? paymentMethods.first
          : null;

      // 2. جلب قائمة العناوين بأمان
      final addresses = await locationServices.fetchLoacations(
        currentUser.uid,
        true,
      );
      final chosenAddress = addresses.isNotEmpty ? addresses.first : null;

      emit(
        CheckoutLoaded(
          chosenPaymentCard: chosenPaymentCard,
          cartItems: cartItems,
          totalAmount: subtotal + shippingValue,
          subtotal: subtotal,
          shippingValue: shippingValue,
          numOfProducts: numOfProducts,
          chosenAddress: chosenAddress,
        ),
      );
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
