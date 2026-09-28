import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCounterWidget extends StatelessWidget {
  final int value;
  final AddToCartModel cartItem;
  final int? initialValue;

  const CartCounterWidget({
    super.key,
    required this.value,
    required this.cartItem,
    this.initialValue,
  });

  // Future<void> _decrementCounter(BuildContext context) async {
  //   final cubit = BlocProvider.of<CartCubit>(context);
  //   if (initialValue != null) {
  //     await cubit.decrementCounter(cartItem, initialValue);
  //   } else {
  //     await cubit.decrementCounter(cartItem);
  //   }
  // }

  // Future<void> _incrementCounter(BuildContext context) async {
  //   final cubit = BlocProvider.of<CartCubit>(context);
  //   if (initialValue != null) {
  //     await cubit.incrementCounter(cartItem, initialValue);
  //   } else {
  //     await cubit.incrementCounter(cartItem);
  //   }
  // }
  Future<void> _decrementCounter(BuildContext context) async {
    final cubit = BlocProvider.of<CartCubit>(context);
    await cubit.decrementCounter(cartItem, value);
  }

  Future<void> _incrementCounter(BuildContext context) async {
    final cubit = BlocProvider.of<CartCubit>(context);
    await cubit.incrementCounter(cartItem, value);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: value > 1 ? () => _decrementCounter(context) : null,
              icon: const Icon(Icons.remove),
            ),
            Text(value.toString()),
            IconButton(
              onPressed: () => _incrementCounter(context),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
