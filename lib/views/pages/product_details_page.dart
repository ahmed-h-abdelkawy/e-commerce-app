import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/product_item_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:e_commerce_app/views/widgets/product_details_counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<ProductDetailsCubit>(context);

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is ProductDetailsLoading ||
          current is ProductDetailsLoaded ||
          current is ProductDetailsError,
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (state is ProductDetailsError) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else if (state is ProductDetailsLoaded) {
          final product = state.product;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Center(child: const Text('Product Details')),
              actions: [
                BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                  bloc: cubit,
                  buildWhen: (previous, current) =>
                      (current is SetFavoriteSuccess &&
                          current.productId == product.id) ||
                      (current is SetFavoriteError &&
                          current.productId == product.id) ||
                      (current is SetFavoriteLoading &&
                          current.productId == product.id),
                  builder: (context, state) {
                    if (state is SetFavoriteLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    // بنفترض إن الحالة المبدئية هي اللي جاية مع المنتج
                    bool isFav = product.isFavorite;

                    // لو الـ State اتغيرت لنجاح، بناخد القيمة الجديدة
                    if (state is SetFavoriteSuccess) {
                      isFav = state.isFavorite;
                    }

                    return IconButton(
                      onPressed: () async => await cubit.setFavorite(product),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.red : null,
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: AppColors.grey2),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      CachedNetworkImage(imageUrl: product.imgUrl),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.45),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 25,
                                        color: AppColors.yellow2,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        product.averageRate.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                                bloc: BlocProvider.of<ProductDetailsCubit>(context),
                                buildWhen: (previous, current) =>
                                    current is QuantityCounterLoaded ||
                                    current is ProductDetailsLoaded,
                                builder: (context, state) {
                                  if (state is QuantityCounterLoaded) {
                                    return ProductDetailsCounterWidget(
                                      value: state.value,
                                      productId: state.productId,
                                    );
                                  } else if (state is ProductDetailsLoaded) {
                                    return ProductDetailsCounterWidget(
                                      value: 1,
                                      productId: product.id,
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Size',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                            bloc: cubit,
                            buildWhen: (previous, current) =>
                                current is SizeSelected ||
                                current is ProductDetailsLoaded,
                            builder: (context, state) {
                              return Row(
                                children: ProductSize.values
                                    .map(
                                      (size) => Padding(
                                        padding: const EdgeInsets.only(
                                          top: 6,
                                          right: 8,
                                        ),
                                        child: InkWell(
                                          onTap: () =>
                                              BlocProvider.of<ProductDetailsCubit>(
                                                context,
                                              ).selectSize(size),
                                          child: Container(
                                            width:
                                                42, // اختر المقاس الثابت المناسب لك (مثلاً 40 أو 42 أو 45)
                                            height: 42,
                                            alignment: Alignment
                                                .center, // لضبط النص في سنتر الدائرة تماماً
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  state is SizeSelected &&
                                                      state.size == size
                                                  ? Theme.of(context).primaryColor
                                                  : AppColors.grey2,
                                            ),
                                            child: Text(
                                              size.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color:
                                                        state is SizeSelected &&
                                                            state.size == size
                                                        ? AppColors.white
                                                        : AppColors.black,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            product.description,
                            style: TextStyle(color: AppColors.black54),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: '\$',
                                  style: Theme.of(context).textTheme.headlineMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: product.price.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                                bloc: cubit,
                                buildWhen: (previous, current) =>
                                    current is ProductAddedToCart ||
                                    current is ProductAddingToCart,
                                builder: (context, state) {
                                  if (state is ProductAddingToCart) {
                                    return ElevatedButton(
                                      onPressed: null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.white,
                                      ),
                                      child:
                                          const CircularProgressIndicator.adaptive(),
                                    );
                                  } else if (state is ProductAddedToCart) {
                                    return ElevatedButton(
                                      onPressed: null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.white,
                                      ),
                                      child: const Text('Added To Cart'),
                                    );
                                  } else {
                                    return ElevatedButton.icon(
                                      onPressed: () {
                                        if (cubit.selectedSize != null) {
                                          cubit.addToCart(productId);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Please Select Size'),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 35,
                                          vertical: 16,
                                        ),
                                        iconSize: 25,
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.white,
                                      ),
                                      label: const Text(
                                        'Add To Cart',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      icon: const Icon(Icons.shopping_bag_outlined),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(body: Center(child: Text('Something went wrong!')));
        }
      },
    );
  }
}
