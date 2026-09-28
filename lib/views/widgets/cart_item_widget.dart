import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:e_commerce_app/views/widgets/cart_counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.grey2,
              borderRadius: BorderRadius.circular(16),
            ), // BoxDecoration
            child: CachedNetworkImage(
              imageUrl: cartItem.product.imgUrl,
              height: 120,
              width: 100,
            ), // CachedNetworkImage
          ), // DecoratedBox
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ), // Text
                Text.rich(
                  TextSpan(
                    text: 'Size: ',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: AppColors.grey),
                    children: [
                      TextSpan(
                        text: cartItem.size.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ), // TextSpan
                    ],
                  ), // TextSpan
                ), // Text.rich
                const SizedBox(height: 8),
                BlocBuilder<CartCubit, CartState>(
                  bloc: cubit,
                  buildWhen: (previous, current) =>
                      (current is QuantityCounterLoaded &&
                          current.productId == cartItem.product.id) ||
                      (current is QuantityCounterLoading) ||
                      (current is QuantityCounterError),
                  builder: (context, state) {
                    if (state is QuantityCounterLoading) {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [CircularProgressIndicator.adaptive()],
                      ); // Row
                    }
                    if (state is QuantityCounterError) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ), // Text
                          ), // Expanded
                        ],
                      ); // Row
                    }
                    if (state is QuantityCounterLoaded) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CartCounterWidget(
                            value: state.value,
                            cartItem: cartItem,
                          ), // CartCounterWidget
                          Text(
                            '\$${(state.value * cartItem.product.price).toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.headlineSmall!
                                .copyWith(fontWeight: FontWeight.w800),
                          ), // Text
                        ],
                      ); // Row
                    }
                    // الحالة الافتراضية (لسه مفيش state خاص بالكاونتر لغاية دلوقتي)
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CartCounterWidget(
                          value: cartItem.quantity,
                          cartItem: cartItem,
                        ), // CartCounterWidget
                        Text(
                          '\$${(cartItem.quantity * cartItem.product.price).toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ); // Row
                  },
                ), // BlocBuilder
              ],
            ), // Column
          ), // Expanded
        ],
      ), // Row
    ); // Padding
  }
}
