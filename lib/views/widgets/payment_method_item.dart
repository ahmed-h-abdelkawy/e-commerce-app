import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/payment_card_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentMethodItem extends StatelessWidget {
  final PaymentCardModel paymentCard;
  final VoidCallback onItemTapped;

  const PaymentMethodItem({
    super.key,
    required this.paymentCard,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemTapped,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.white,
          border: Border.all(color: AppColors.grey2),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl:
                'https://www.freepnglogos.com/uploads/mastercard-png/mastercard-logo-png-transparent-svg-vector-bie-supply-0.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          title: Text('MasterCard'),
          subtitle: Text(paymentCard.cardNumber),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
