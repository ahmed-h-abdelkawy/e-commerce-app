import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/utils/app_routes.dart';
import 'package:e_commerce_app/view_models/payment_methods_cubit/payment_methods_cubit.dart';
import 'package:e_commerce_app/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethodsCubit = BlocProvider.of<PaymentMethodsCubit>(context);

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 36, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              BlocBuilder(
                bloc: paymentMethodsCubit,
                buildWhen: (previous, current) =>
                    current is FetchedPaymentMethods ||
                    current is FetchPaymentMethodsError ||
                    current is FetchingPaymentMethods,
                builder: (_, state) {
                  if (state is FetchingPaymentMethods) {
                    return Center(child: const CircularProgressIndicator.adaptive());
                  } else if (state is FetchedPaymentMethods) {
                    final paymentCards = state.paymentCards;
                    return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
                      bloc: paymentMethodsCubit,
                      buildWhen: (previous, current) =>
                          current is PaymentMethodChosen,
                      builder: (context, state) {
                        if (state is PaymentMethodChosen) {
                          final chosenPaymentMethtod = state.chosenPayment;
                          return RadioGroup<String>(
                            groupValue: chosenPaymentMethtod.id,
                            onChanged: (id) {
                              paymentMethodsCubit.changePaymentMethod(id!);
                            },
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paymentCards.length,
                              itemBuilder: (_, index) {
                                final paymentCard = paymentCards[index];
                                return Card(
                                  color: AppColors.white2,
                                  elevation: 0,
                                  child: ListTile(
                                    onTap: () {
                                      paymentMethodsCubit.changePaymentMethod(
                                        paymentCard.id,
                                      );
                                    },
                                    leading: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.grey2,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 8,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://www.freepnglogos.com/uploads/mastercard-png/mastercard-logo-png-transparent-svg-vector-bie-supply-0.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    title: Text(paymentCard.cardNumber),
                                    subtitle: Text(paymentCard.cardHolderName),
                                    trailing: Radio<String>(value: paymentCard.id),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  } else if (state is FetchPaymentMethodsError) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(
                        AppRoutes.addNewCardRoute,
                        arguments: paymentMethodsCubit,
                      )
                      .then(
                        (value) async =>
                            await paymentMethodsCubit.fetchPaymentMethods(),
                      );
                },
                child: Card(
                  color: AppColors.white2,
                  elevation: 0,
                  child: ListTile(
                    leading: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.grey2,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.add),
                      ),
                    ),
                    title: Text('Add Payment Method'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                bloc: paymentMethodsCubit,
                listenWhen: (previous, current) => current is ConfirmPaymentSuccess,
                buildWhen: (previous, current) =>
                    current is ConfirmPaymentLoading ||
                    current is ConfirmPaymentSuccess ||
                    current is ConfirmPaymentFailure,
                listener: (context, state) {
                  if (state is ConfirmPaymentSuccess) {
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  if (state is ConfirmPaymentLoading) {
                    return MainButton(isLoading: true, onTap: null);
                  }
                  return MainButton(
                    text: 'Confirm Payment',
                    onTap: () {
                      paymentMethodsCubit.confirmPaymentMethod();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
