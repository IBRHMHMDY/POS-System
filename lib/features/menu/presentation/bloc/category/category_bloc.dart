import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/usecases/usecase.dart';
import '../../../domain/usecases/categories/add_category_usecase.dart';
import '../../../domain/usecases/categories/delete_category_usecase.dart';
import '../../../domain/usecases/categories/get_all_categories_usecase.dart';
import '../../../domain/usecases/categories/update_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final AddCategoryUseCase addCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryBloc({
    required this.getAllCategoriesUseCase,
    required this.addCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
  }) : super(CategoryInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await getAllCategoriesUseCase(const NoParams());
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await addCategoryUseCase(event.category);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {
        emit(const CategoryActionSuccess('تمت إضافة القسم بنجاح'));
        add(LoadCategoriesEvent()); // إعادة جلب البيانات لتحديث القائمة
      },
    );
  }

  Future<void> _onUpdateCategory(UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await updateCategoryUseCase(event.category);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {
        emit(const CategoryActionSuccess('تم تعديل القسم بنجاح'));
        add(LoadCategoriesEvent());
      },
    );
  }

  Future<void> _onDeleteCategory(DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await deleteCategoryUseCase(event.categoryId);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {
        emit(const CategoryActionSuccess('تم حذف القسم بنجاح'));
        add(LoadCategoriesEvent());
      },
    );
  }
}