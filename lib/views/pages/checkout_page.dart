import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/location_item_model.dart';
import 'package:e_commerce_app/models/payment_card_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/utils/app_routes.dart';
import 'package:e_commerce_app/view_models/payment_methods_cubit/payment_methods_cubit.dart';
import 'package:e_commerce_app/view_models/checkout_cubit/checkout_cubit.dart';
import 'package:e_commerce_app/views/widgets/checkout_headlines_item.dart';
import 'package:e_commerce_app/views/widgets/empty_shipping_payment.dart';
import 'package:e_commerce_app/views/widgets/label_with_value_row.dart';
import 'package:e_commerce_app/views/widgets/payment_method_bottom_sheet.dart';
import 'package:e_commerce_app/views/widgets/payment_method_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  Widget _buildPaymentMethodItem(
    PaymentCardModel? chosenCard,
    BuildContext context,
  ) {
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);
    // final paymentCubit = BlocProvider.of<PaymentMethodsCubit>(context);
    if (chosenCard != null) {
      return PaymentMethodItem(
        paymentCard: chosenCard,
        onItemTapped: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                child: BlocProvider(
                  create: (context) {
                    final cubit = PaymentMethodsCubit();
                    cubit.fetchPaymentMethods();
                    return cubit;
                  },
                  child: const PaymentMethodBottomSheet(),
                ),
              );
            },
          ).then((value) async {
            if (!context.mounted) return;
            await checkoutCubit.getCheckoutContant();
          });
        },
      );
    } else {
      return const EmptyShippingAndPayment(
        title: 'Add Payment Method',
        isPayment: true,
      );
    }
  }

  Widget _buildShippingItem(LocationItemModel? chosenAddress, BuildContext context) {
    if (chosenAddress != null) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(24),
            child: CachedNetworkImage(
              imageUrl: chosenAddress.imgUrl,
              width: 140,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chosenAddress.city,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${chosenAddress.city},${chosenAddress.country}',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ],
      );
    } else {
      return const EmptyShippingAndPayment(
        title: 'Add Shipping Address',
        isPayment: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = CheckoutCubit();
            cubit.getCheckoutContant();
            return cubit;
          },
        ),
        BlocProvider(create: (context) => PaymentMethodsCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: Builder(
          builder: (context) {
            final cubit = BlocProvider.of<CheckoutCubit>(context);

            return BlocBuilder<CheckoutCubit, CheckoutState>(
              bloc: cubit,
              buildWhen: (previous, current) =>
                  current is CheckoutLoaded ||
                  current is CheckoutLoading ||
                  current is CheckoutError,
              builder: (context, state) {
                if (state is CheckoutLoading) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else if (state is CheckoutError) {
                  return Center(child: Text(state.message));
                } else if (state is CheckoutLoaded) {
                  final cartItems = state.cartItems;
                  final chosenPaymentCard = state.chosenPaymentCard;
                  final chosenAddress = state.chosenAddress;
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            CheckoutHeadlinesItem(
                              title: 'Address',
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.chooseLocation)
                                    .then(
                                      (value) async =>
                                          await cubit.getCheckoutContant(),
                                    );
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildShippingItem(chosenAddress, context),
                            const SizedBox(height: 24),
                            CheckoutHeadlinesItem(
                              title: 'Products',
                              numOfProducts: state.numOfProducts,
                            ),
                            const SizedBox(height: 16),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cartItems.length,
                              separatorBuilder: (context, index) {
                                return Divider(
                                  indent: 20,
                                  endIndent: 20,
                                  color: AppColors.grey2,
                                );
                              },
                              itemBuilder: (context, index) {
                                final cartItem = cartItems[index];
                                return Row(
                                  children: [
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.grey2,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: cartItem.product.imgUrl,
                                        height: 120,
                                        width: 100,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.product.name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Size: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: AppColors.grey,
                                                      ),
                                                  children: [
                                                    TextSpan(
                                                      text: cartItem.size.name,
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.titleMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '\$${cartItem.totalPrice.toStringAsFixed(1)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Quantity: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(color: AppColors.grey),
                                              children: [
                                                TextSpan(
                                                  text: cartItem.quantity.toString(),
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            const CheckoutHeadlinesItem(title: 'Payment Method'),
                            const SizedBox(height: 16),
                            _buildPaymentMethodItem(chosenPaymentCard, context),
                            const SizedBox(height: 16),
                            CheckoutHeadlinesItem(title: 'Payment'),
                            Divider(indent: 4, endIndent: 4, color: AppColors.grey2),
                            const SizedBox(height: 16),
                            LabelWithValueRow(
                              label: 'Subtotal',
                              value: '\$${state.subtotal.toStringAsFixed(1)}',
                            ),
                            const SizedBox(height: 8),
                            LabelWithValueRow(
                              label: 'Shipping',
                              value: '\$${state.shippingValue.toStringAsFixed(1)}',
                            ),
                            const SizedBox(height: 8),
                            LabelWithValueRow(
                              label: 'Total Amount',
                              value: '\$${state.totalAmount.toStringAsFixed(1)}',
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 60,

                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: AppColors.white,
                                ),
                                child: const Text('Proceed to Buy'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Something Went Wrong'));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
