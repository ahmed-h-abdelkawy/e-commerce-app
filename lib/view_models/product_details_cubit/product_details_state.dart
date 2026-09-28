part of 'product_details_cubit.dart';

sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsLoaded extends ProductDetailsState {
  final ProductItemModel product;

  ProductDetailsLoaded({required this.product});
}

final class QuantityCounterLoaded extends ProductDetailsState {
  final int value;
  final String productId;

  QuantityCounterLoaded({required this.value, required this.productId});
}
final class SizeSelected extends ProductDetailsState {
  final ProductSize size;

  SizeSelected({required this.size});
}

final class ProductAddedToCart extends ProductDetailsState {
  final String productId;

  ProductAddedToCart({required this.productId});
}

final class ProductAddingToCart extends ProductDetailsState {}

final class ProductAddToCartError extends ProductDetailsState {
  final String message;

  ProductAddToCartError(this.message);
}

final class ProductDetailsError extends ProductDetailsState {
  final String message;

  ProductDetailsError(this.message);
}

final class SetFavoriteLoading extends ProductDetailsState {
  final String productId;
  SetFavoriteLoading({required this.productId});
}

final class SetFavoriteSuccess extends ProductDetailsState {
  final bool isFavorite;
  final String productId;
  SetFavoriteSuccess({required this.isFavorite, required this.productId});
}

final class SetFavoriteError extends ProductDetailsState {
  final String message;
  final String productId;
  SetFavoriteError(this.message, this.productId);
}
