import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/invoice_entity.dart';

class CheckoutDialog extends StatefulWidget {
  final double grandTotal;

  const CheckoutDialog({super.key, required this.grandTotal});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  PaymentMethod _selectedMethod = PaymentMethod.cash;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'إتمام الدفع',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('المطلوب سداده', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.grandTotal.toStringAsFixed(2)} ج.م',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('طريقة الدفع:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              RadioListTile<PaymentMethod>(
                title: const Text('نقدي (Cash)'),
                value: PaymentMethod.cash,
                groupValue: _selectedMethod,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _selectedMethod = val!),
              ),
              RadioListTile<PaymentMethod>(
                title: const Text('بطاقة ائتمان (Visa)'),
                value: PaymentMethod.visa,
                groupValue: _selectedMethod,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _selectedMethod = val!),
              ),
              RadioListTile<PaymentMethod>(
                title: const Text('آجل (Later)'),
                value: PaymentMethod.later,
                groupValue: _selectedMethod,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _selectedMethod = val!),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(_selectedMethod),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('تأكيد البيع', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}