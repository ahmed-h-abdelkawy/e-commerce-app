import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/location_item_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LocationItemWidget extends StatelessWidget {
  final Color borderColor;
  final VoidCallback onTap;
  final LocationItemModel location;

  const LocationItemWidget({
    super.key,
    this.borderColor = AppColors.grey,
    required this.onTap,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.city,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${location.city},${location.country}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    CircleAvatar(radius: 40, backgroundColor: borderColor),
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: CachedNetworkImageProvider(
                        location.imgUrl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
