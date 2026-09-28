import 'package:e_commerce_app/models/category_model.dart';
import 'package:e_commerce_app/services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final homeServices = HomeServicesImpl();

  Future<void> getCategoriesData() async {
    emit(CategoryLoading());
    try {
      final categories = await homeServices.fetchCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
