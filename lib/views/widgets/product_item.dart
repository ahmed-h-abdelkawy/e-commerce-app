import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/product_item_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;
  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 205,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.grey2,
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 205,
                  child: CachedNetworkImage(
                    imageUrl: productItem.imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator.adaptive()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: BlocBuilder<HomeCubit, HomeState>(
                  bloc: homeCubit,
                  buildWhen: (previous, current) =>
                      (current is SetFavoriteSuccess &&
                          current.productId == productItem.id) ||
                      (current is SetFavoriteError &&
                          current.productId == productItem.id) ||
                      (current is SetFavoriteLoading &&
                          current.productId == productItem.id),
                  builder: (context, state) {
                    if (state is SetFavoriteLoading) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is SetFavoriteSuccess) {
                      return state.isFavorite
                          ? InkWell(
                              onTap: () async =>
                                  await homeCubit.setFavorite(productItem),
                              child: const Icon(
                                Icons.favorite,
                                color: AppColors.red,
                              ),
                            )
                          : InkWell(
                              onTap: () async => homeCubit.setFavorite(productItem),
                              child: const Icon(Icons.favorite_border),
                            );
                    }
                    return InkWell(
                      onTap: () async => await homeCubit.setFavorite(productItem),
                      child: productItem.isFavorite
                          ? Icon(Icons.favorite, color: AppColors.red)
                          : Icon(Icons.favorite_border),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          productItem.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          productItem.category,
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(color: Colors.grey),
        ),
        Text(
          '\$${productItem.price}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
