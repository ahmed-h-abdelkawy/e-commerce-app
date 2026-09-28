import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/utils/app_routes.dart';
import 'package:e_commerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:e_commerce_app/views/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CartCubit();
        cubit.getCartItems();
        return cubit;
      },
      child: Builder(
        builder: (context) {
          final cubit = BlocProvider.of<CartCubit>(context);
          return BlocBuilder<CartCubit, CartState>(
            bloc: cubit,
            buildWhen: (previous, current) =>
                current is CartLoaded ||
                current is CartLoading ||
                current is CartError,
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator.adaptive());
              } else if (state is CartLoaded) {
                final cartItems = state.cartItems;
                if (cartItems.isEmpty) {
                  return const Center(child: Text('No items in your cart!'));
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return CartItemWidget(cartItem: cartItem);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            indent: 20,
                            endIndent: 20,
                            color: AppColors.grey2,
                          );
                        },
                      ),
                      Divider(indent: 20, endIndent: 20, color: AppColors.grey2),
                      BlocBuilder<CartCubit, CartState>(
                        bloc: cubit,
                        buildWhen: (previous, current) =>
                            current is SubtotalUpdated || current is CartLoaded,
                        builder: (context, subtotalState) {
                          double subtotal = 0.0;

                          if (subtotalState is SubtotalUpdated) {
                            subtotal = subtotalState.subtotal;
                          } else if (subtotalState is CartLoaded) {
                            subtotal = subtotalState.cartItems.fold(
                              0.0,
                              (sum, item) =>
                                  sum + (item.product.price * item.quantity),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              totalAndSubtotalWidget(
                                context,
                                title: 'Subtotal',
                                amount: subtotal,
                              ),
                              totalAndSubtotalWidget(
                                context,
                                title: 'Shipping',
                                amount: 10,
                              ),
                              const SizedBox(height: 4),
                              Dash(
                                dashColor: AppColors.grey3,
                                length: MediaQuery.of(context).size.width - 32,
                              ),
                              const SizedBox(height: 4),
                              totalAndSubtotalWidget(
                                context,
                                title: 'Total Amount',
                                amount: subtotal + 10,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: 350,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: AppColors.white,
                            ),
                            onPressed: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(AppRoutes.checkoutRoute);
                            },
                            child: Text(
                              'Checkout',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is CartError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('Something went wrong!'));
              }
            },
          );
        },
      ),
    );
  }

  Widget totalAndSubtotalWidget(
    BuildContext context, {
    required String title,
    required double amount,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: AppColors.grey),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
