import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCounterWidget extends StatelessWidget {
  final int value;
  final String productId;

  const ProductDetailsCounterWidget({
    super.key,
    required this.value,
    required this.productId,
  });

  void _decrementCounter(BuildContext context) {
    final cubit = BlocProvider.of<ProductDetailsCubit>(context);
    cubit.decrementCounter(productId);
  }

  void _incrementCounter(BuildContext context) {
    final cubit = BlocProvider.of<ProductDetailsCubit>(context);
    cubit.incrementCounter(productId);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ), // BoxDecoration
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: value > 1 ? () => _decrementCounter(context) : null,
              icon: const Icon(Icons.remove),
            ), // IconButton
            Text(value.toString()),
            IconButton(
              onPressed: () => _incrementCounter(context),
              icon: const Icon(Icons.add),
            ), // IconButton
          ],
        ), // Row
      ), // Padding
    ); // DecoratedBox
  }
}
