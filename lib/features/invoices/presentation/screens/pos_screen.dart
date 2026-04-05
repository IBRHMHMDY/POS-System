import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../menu/presentation/bloc/category/category_bloc.dart';
import '../../../menu/presentation/bloc/category/category_event.dart';
import '../../../menu/presentation/bloc/product/product_bloc.dart';
import '../../../menu/presentation/bloc/product/product_event.dart';
import '../../../shifts/presentation/bloc/shift/shift_bloc.dart';
import '../../../shifts/presentation/bloc/shift/shift_event.dart';
import '../../../shifts/presentation/bloc/shift/shift_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import '../widgets/pos_cart_section.dart';
import '../widgets/pos_products_section.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  @override
  void initState() {
    super.initState();
    // 1. التحقق من الوردية
    context.read<ShiftBloc>().add(CheckCurrentShiftEvent());
    // 2. تحميل الأقسام والمنتجات المبدئية
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
    context.read<ProductBloc>().add(LoadAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نقطة البيع (POS)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state.message != null) {
            final isError = state.status == CartStatus.error;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: isError ? AppColors.error : AppColors.success,
              ),
            );
          }
        },
        // نراقب حالة الوردية لأن البيع مستحيل بدون وردية مفتوحة
        child: BlocBuilder<ShiftBloc, ShiftState>(
          builder: (context, shiftState) {
            if (shiftState is ShiftLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (shiftState is CurrentShiftLoaded) {
              final shift = shiftState.shift;
              
              if (shift == null) {
                // لا توجد وردية مفتوحة
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 100, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('نقطة البيع مغلقة', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      const Text('يجب فتح وردية / استلام عهدة الدرج أولاً للتمكن من البيع.', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              }

              // الوردية مفتوحة، نعرض شاشة نقطة البيع (Split-Screen)
              return Row(
                children: [
                  // الجانب الأيمن (لأن التطبيق RTL): سلة المشتريات
                  Expanded(
                    flex: 4, // 40% من عرض الشاشة
                    child: PosCartSection(activeShift: shift),
                  ),
                  const VerticalDivider(width: 1, color: Colors.grey),
                  // الجانب الأيسر: الأقسام والمنتجات
                  const Expanded(
                    flex: 6, // 60% من عرض الشاشة
                    child: PosProductsSection(),
                  ),
                ],
              );
            }
            return const Center(child: Text('جاري تحميل بيانات النظام...'));
          },
        ),
      ),
    );
  }
}