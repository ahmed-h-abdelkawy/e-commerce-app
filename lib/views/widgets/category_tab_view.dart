import 'package:e_commerce_app/view_models/category_cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading || state is CategoryInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CategoryError) {
          return Center(child: Text(state.message));
        }
        final categories = (state as CategoryLoaded).categories;
        return ListView.builder(
          itemBuilder: (context, index) {
            final category = categories[index];
            final bool isTextOnLeft = index % 2 == 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(),
                    child: SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          // 1. الصورة الخلفية
                          Positioned.fill(
                            child: Image.asset(
                              category.imgPath,
                              fit: BoxFit.cover, // عشان تملا الكارد بالكامل
                            ), // Image.asset
                          ), // Positioned.fill
                          // 2. طبقة تدرج لوني (Gradient) فوق الصورة عشان تخلي الكلام واضح مهما كانت ألوان الصورة
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(
                                      alpha: 0.6,
                                    ), // لون غامق تحت النص
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ), // LinearGradient
                              ), // BoxDecoration
                            ), // DecoratedBox
                          ), // Positioned.fill
                          // 3. النصوص
                          Positioned(
                            top: 32,
                            left: isTextOnLeft ? 16 : null,
                            right: isTextOnLeft ? null : 16,
                            child: Column(
                              crossAxisAlignment: isTextOnLeft
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.titleLarge!
                                      .copyWith(
                                        color: Colors.white, // تثبيت لون النص أبيض
                                        fontWeight: FontWeight.w600,
                                      ),
                                ), // Text
                                Text(
                                  '${category.productsCount} Product',
                                  style: Theme.of(context).textTheme.titleMedium!
                                      .copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ), // أبيض شفاف قليلا لتعدد
                                        fontWeight: FontWeight.w500,
                                      ),
                                ), // Text
                              ],
                            ), // Column
                          ), // Positioned
                        ],
                      ), // Stack
                    ), // SizedBox
                  ), // DecoratedBox
                ), // ClipRRect
              ), // InkWell
            ); // Padding
          },
          itemCount: categories.length,
        ); // ListView.builder
      },
    );
  }
}
