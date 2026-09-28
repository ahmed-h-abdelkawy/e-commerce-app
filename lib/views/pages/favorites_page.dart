import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/view_models/favorite_cubit/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);

//     return BlocBuilder<FavoriteCubit, FavoriteState>(
//       bloc: favoriteCubit,
//       buildWhen: (previous, current) =>
//           current is FavoriteLoading ||
//           current is FavoriteLoaded ||
//           current is FavoriteError,
//       builder: (context, state) {
//         if (state is FavoriteLoading) {
//           return const Center(child: CircularProgressIndicator.adaptive());
//         } else if (state is FavoriteLoaded) {
//           final favoriteProducts = state.favoriteProducts;
//           if (favoriteProducts.isEmpty) {
//             return const Center(child: Text('No Favorites Yet'));
//           }
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
//             child: RefreshIndicator(
//               onRefresh: () async {
//                 await favoriteCubit.getFavoriteProducts();
//               },
//               child: ListView.separated(
//                 separatorBuilder: (context, index) {
//                   return const Divider(
//                     indent: 15,
//                     endIndent: 15,
//                     color: AppColors.primary,
//                     thickness: 0.8,
//                   );
//                 },
//                 itemCount: favoriteProducts.length,
//                 itemBuilder: (context, index) {
//                   final product = favoriteProducts[index];
//                   return ListTile(
//                     title: Text(product.name),
//                     subtitle: Text(product.price.toString()),
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(product.imgUrl),
//                       radius: 30,
//                     ),
//                     trailing: BlocConsumer<FavoriteCubit, FavoriteState>(
//                       bloc: favoriteCubit,
//                       listenWhen: (previous, current) =>
//                           current is FavoriteRemoveError,
//                       listener: (context, state) {
//                         if (state is FavoriteRemoveError) {
//                           ScaffoldMessenger.of(
//                             context,
//                           ).showSnackBar(SnackBar(content: Text(state.error)));
//                         }
//                       },
//                       buildWhen: (previous, current) =>
//                           (current is FavoriteRemoving &&
//                               current.productId == product.id) ||
//                           (current is FavoriteRemoved &&
//                               current.productId == product.id) ||
//                           current is FavoriteRemoveError,
//                       builder: (context, state) {
//                         if (state is FavoriteRemoving) {
//                           return const CircularProgressIndicator.adaptive();
//                         }
//                         return IconButton(
//                           icon: const Icon(Icons.delete, color: AppColors.primary),
//                           onPressed: () async {
//                             await favoriteCubit.removeFavorite(product.id);
//                           },
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         } else if (state is FavoriteError) {
//           return Center(child: Text(state.error));
//         } else {
//           return const SizedBox();
//         }
//       },
//     );
//   }
// }
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);

    // 1. جلب المنتجات تلقائياً إذا كانت الشاشة في الحالة الابتدائية
    if (favoriteCubit.state is FavoriteInitial) {
      favoriteCubit.getFavoriteProducts();
    }

    return BlocListener<FavoriteCubit, FavoriteState>(
      // 2. وضع المستمع في أعلى الشجرة لضمان إظهار الـ SnackBar مرة واحدة فقط
      listenWhen: (previous, current) => current is FavoriteRemoveError,
      listener: (context, state) {
        if (state is FavoriteRemoveError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        bloc: favoriteCubit,
        buildWhen: (previous, current) =>
            current is FavoriteLoading ||
            current is FavoriteLoaded ||
            current is FavoriteError,
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is FavoriteLoaded) {
            final favoriteProducts = state.favoriteProducts;
            if (favoriteProducts.isEmpty) {
              return const Center(child: Text('No Favorites Yet'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              child: RefreshIndicator(
                onRefresh: () async {
                  await favoriteCubit.getFavoriteProducts();
                },
                child: ListView.separated(
                  itemCount: favoriteProducts.length,
                  separatorBuilder: (context, index) => const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: AppColors.primary,
                    thickness: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final product = favoriteProducts[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.price.toString()),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(product.imgUrl),
                        radius: 30,
                      ),
                      trailing: BlocBuilder<FavoriteCubit, FavoriteState>(
                        bloc: favoriteCubit,
                        // 3. تحديث زر الحذف عند التحميل أو عند صدور قائمة جديدة
                        buildWhen: (previous, current) =>
                            (current is FavoriteRemoving &&
                                current.productId == product.id) ||
                            (current is FavoriteLoaded),
                        builder: (context, state) {
                          if (state is FavoriteRemoving &&
                              state.productId == product.id) {
                            return const CircularProgressIndicator.adaptive();
                          }
                          return IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.primary),
                            onPressed: () async {
                              await favoriteCubit.removeFavorite(product.id);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is FavoriteError) {
            return Center(child: Text(state.error));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
