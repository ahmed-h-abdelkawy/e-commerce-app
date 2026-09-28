import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/utils/app_routes.dart';
import 'package:e_commerce_app/view_models/checkout_cubit/checkout_cubit.dart';
import 'package:e_commerce_app/view_models/payment_methods_cubit/payment_methods_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyShippingAndPayment extends StatelessWidget {
  final String title;
  final bool isPayment;
  const EmptyShippingAndPayment({
    super.key,
    required this.title,
    required this.isPayment,
  });

  @override
  Widget build(BuildContext context) {
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);
    final paymentCubit = BlocProvider.of<PaymentMethodsCubit>(context);

    return InkWell(
      onTap: () {
        if (isPayment) {
          Navigator.of(context)
              .pushNamed(AppRoutes.addNewCardRoute, arguments: paymentCubit)
              .then((value) async => await checkoutCubit.getCheckoutContant());
        } else {
          Navigator.of(context)
              .pushNamed(AppRoutes.chooseLocation)
              .then((value) async => await checkoutCubit.getCheckoutContant());
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey3,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Icon(Icons.add, size: 30),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
