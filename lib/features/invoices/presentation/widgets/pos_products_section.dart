import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../menu/presentation/bloc/category/category_bloc.dart';
import '../../../menu/presentation/bloc/category/category_state.dart';
import '../../../menu/presentation/bloc/product/product_bloc.dart';
import '../../../menu/presentation/bloc/product/product_event.dart';
import '../../../menu/presentation/bloc/product/product_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';

class PosProductsSection extends StatefulWidget {
  const PosProductsSection({super.key});

  @override
  State<PosProductsSection> createState() => _PosProductsSectionState();
}

class _PosProductsSectionState extends State<PosProductsSection> {
  int? _selectedCategoryId;

  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    if (categoryId != null) {
      context.read<ProductBloc>().add(LoadProductsByCategoryEvent(categoryId));
    } else {
      context.read<ProductBloc>().add(LoadAllProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. شريط البحث
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'البحث عن منتج (الاسم أو الباركود)...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                // يمكن تطوير البحث ليشمل الاسم لاحقاً، حالياً يدعم الباركود حسب الـ UseCase
                context.read<ProductBloc>().add(SearchProductByBarcodeEvent(value.trim()));
              } else {
                _onCategorySelected(_selectedCategoryId);
              }
            },
          ),
        ),
        
        // 2. شريط الأقسام (Categories)
        SizedBox(
          height: 60,
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.categories.length + 1,
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final isSelected = isAll ? _selectedCategoryId == null : _selectedCategoryId == state.categories[index - 1].id;
                    
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ChoiceChip(
                        label: Text(isAll ? 'الكل' : state.categories[index - 1].name),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        onSelected: (_) => _onCategorySelected(isAll ? null : state.categories[index - 1].id),
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        const Divider(),
        
        // 3. شبكة المنتجات (Products Grid)
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) return const Center(child: CircularProgressIndicator());
              if (state is ProductsLoaded) {
                if (state.products.isEmpty) return const Center(child: Text('لا توجد منتجات'));
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.85, // حماية من الـ Overflow
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: product.isActive ? () {
                          context.read<CartBloc>().add(AddProductToCartEvent(product));
                        } : null, // تعطيل الضغط إذا كان غير متوفر
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Icon(Icons.fastfood, size: 40, color: Colors.grey), // مؤقت بدلاً من الصورة
                                  const Spacer(),
                                  Text(product.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 8),
                                  Text('${product.price} ج.م', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                            if (!product.isActive)
                              Container(
                                color: Colors.white.withOpacity(0.7),
                                alignment: Alignment.center,
                                child: const Center(child: Text('غير متوفر', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 18))),
                              ),
                          ],
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
    );
  }
}