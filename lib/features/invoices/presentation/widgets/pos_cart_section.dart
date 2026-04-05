import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../shifts/domain/entities/shift_entity.dart';
import '../../domain/entities/invoice_entity.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import 'checkout_dialog.dart';

class PosCartSection extends StatelessWidget {
  final ShiftEntity activeShift;

  const PosCartSection({super.key, required this.activeShift});

  void _onCheckoutPressed(BuildContext context, CartState state) async {
    if (state.items.isEmpty) return;

    final selectedPaymentMethod = await showDialog<PaymentMethod>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CheckoutDialog(grandTotal: state.grandTotal),
    );

    if (selectedPaymentMethod != null && context.mounted) {
      context.read<CartBloc>().add(CheckoutCartEvent(
        shiftId: activeShift.id,
        userId: activeShift.userId,
        paymentMethod: selectedPaymentMethod,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // عنوان السلة
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: const Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.white),
                SizedBox(width: 8),
                Text('سلة المشتريات (الفاتورة الحالية)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // قائمة المنتجات في السلة
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.items.isEmpty) {
                  return const Center(child: Text('السلة فارغة، قم بإضافة منتجات', style: TextStyle(color: Colors.grey)));
                }
                return ListView.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return ListTile(
                      title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${item.product.price} ج.م'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                            onPressed: () => context.read<CartBloc>().add(UpdateCartItemQuantityEvent(item.product.id, item.quantity - 1)),
                          ),
                          Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.success),
                            onPressed: () => context.read<CartBloc>().add(UpdateCartItemQuantityEvent(item.product.id, item.quantity + 1)),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 70,
                            child: Text('${item.totalPrice.toStringAsFixed(2)} ج', textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // قسم الإجماليات والدفع
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('الإجمالي (قبل الخصم):', state.subTotal),
                    _buildSummaryRow('الضريبة:', state.tax),
                    _buildSummaryRow('الخصم:', state.discount, isDiscount: true),
                    const Divider(height: 24, thickness: 2),
                    _buildSummaryRow('المطلوب سداده:', state.grandTotal, isGrandTotal: true),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 16)),
                            onPressed: state.items.isEmpty ? null : () => context.read<CartBloc>().add(ClearCartEvent()),
                            child: const Text('إلغاء', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, padding: const EdgeInsets.symmetric(vertical: 16)),
                            onPressed: state.items.isEmpty || state.status == CartStatus.loading ? null : () => _onCheckoutPressed(context, state),
                            child: state.status == CartStatus.loading 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('دفع (Checkout)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, double amount, {bool isGrandTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: isGrandTotal ? 18 : 14, fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            '${isDiscount ? '-' : ''}${amount.toStringAsFixed(2)} ج.م',
            style: TextStyle(
              fontSize: isGrandTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: isGrandTotal ? AppColors.success : (isDiscount ? AppColors.error : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}