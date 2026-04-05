import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';
import '../widgets/category_dialog.dart';
import '../widgets/product_dialog.dart';

class MenuAdminScreen extends StatefulWidget {
  const MenuAdminScreen({super.key});

  @override
  State<MenuAdminScreen> createState() => _MenuAdminScreenState();
}

class _MenuAdminScreenState extends State<MenuAdminScreen> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // جلب الأقسام بمجرد فتح الشاشة
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  void _showCategoryDialog([CategoryEntity? category]) async {
    final result = await showDialog<CategoryEntity>(
      context: context,
      builder: (ctx) => CategoryDialog(category: category),
    );

    if (result != null && mounted) {
      if (category == null) {
        context.read<CategoryBloc>().add(AddCategoryEvent(result));
      } else {
        context.read<CategoryBloc>().add(UpdateCategoryEvent(result));
      }
    }
  }

  void _showProductDialog([ProductEntity? product]) async {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تحديد القسم أولاً')),
      );
      return;
    }

    final result = await showDialog<ProductEntity>(
      context: context,
      builder: (ctx) => ProductDialog(product: product, categoryId: _selectedCategoryId!),
    );

    if (result != null && mounted) {
      if (product == null) {
        context.read<ProductBloc>().add(AddProductEvent(result));
      } else {
        context.read<ProductBloc>().add(UpdateProductEvent(result));
      }
      // إعادة تحميل منتجات القسم بعد التعديل أو الإضافة
      context.read<ProductBloc>().add(LoadProductsByCategoryEvent(_selectedCategoryId!));
    }
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    context.read<ProductBloc>().add(LoadProductsByCategoryEvent(categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة قائمة الطعام'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.success));
              } else if (state is CategoryError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
              }
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.success));
              } else if (state is ProductError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
              }
            },
          ),
        ],
        child: Row(
          children: [
            // الجانب الأيمن: الأقسام
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _showCategoryDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة قسم جديد'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is CategoriesLoaded) {
                            if (state.categories.isEmpty) {
                              return const Center(child: Text('لا توجد أقسام مسجلة'));
                            }
                            return ListView.separated(
                              itemCount: state.categories.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final category = state.categories[index];
                                final isSelected = _selectedCategoryId == category.id;
                                return ListTile(
                                  selected: isSelected,
                                  selectedTileColor: AppColors.primary.withOpacity(0.1),
                                  title: Text(category.name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                                  subtitle: Text(category.isActive ? 'نشط' : 'غير نشط', style: TextStyle(color: category.isActive ? AppColors.success : AppColors.error)),
                                  onTap: () => _onCategorySelected(category.id),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit, color: AppColors.textSecondary),
                                    onPressed: () => _showCategoryDialog(category),
                                  ),
                                );
                              },
                            );
                          }
                          return const Center(child: Text('الرجاء إضافة قسم للبدء'));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1, color: Colors.grey),
            // الجانب الأيسر: المنتجات
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: AppColors.background,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategoryId == null ? 'يرجى تحديد قسم لعرض المنتجات' : 'المنتجات الخاصة بالقسم المتبوع',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ElevatedButton.icon(
                          onPressed: _selectedCategoryId == null ? null : () => _showProductDialog(),
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة منتج للقسم'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (_selectedCategoryId == null) {
                          return const Center(child: Icon(Icons.touch_app, size: 80, color: Colors.grey));
                        }

                        if (state is ProductLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ProductsLoaded) {
                          if (state.products.isEmpty) {
                            return const Center(child: Text('لا توجد منتجات في هذا القسم'));
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 250,
                              childAspectRatio: 1.0, // <-- تم تعديل النسبة لتوفير مساحة طولية أكبر للكارت
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: InkWell(
                                  onTap: () => _showProductDialog(product),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    // تم إضافة SingleChildScrollView لمنع الخطأ إذا كان النص طويلاً
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            product.name, 
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), 
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Text('${product.price} ج.م', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 8),
                                          if (product.barcode != null)
                                            Text('باركود: ${product.barcode}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: product.isActive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              product.isActive ? 'متوفر' : 'غير متوفر',
                                              style: TextStyle(color: product.isActive ? AppColors.success : AppColors.error, fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}