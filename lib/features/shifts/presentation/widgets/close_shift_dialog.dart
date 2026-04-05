import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CloseShiftDialog extends StatefulWidget {
  final double expectedCash; // المبلغ المتوقع لكي نساعد الكاشير
  
  const CloseShiftDialog({super.key, required this.expectedCash});

  @override
  State<CloseShiftDialog> createState() => _CloseShiftDialogState();
}

class _CloseShiftDialogState extends State<CloseShiftDialog> {
  final _formKey = GlobalKey<FormState>();
  final _actualCashController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final actualCash = double.tryParse(_actualCashController.text.trim()) ?? 0.0;
      Navigator.of(context).pop(actualCash);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('إغلاق الوردية وجرد الدرج', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.error), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('المبلغ المتوقع في الدرج: ${widget.expectedCash} ج.م', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _actualCashController,
                  decoration: const InputDecoration(labelText: 'النقدية الفعلية بعد الجرد', suffixText: 'ج.م'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value == null || value.trim().isEmpty || double.tryParse(value) == null ? 'أدخل مبلغاً صحيحاً' : null,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary))),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                      onPressed: _submit, 
                      child: const Text('تأكيد الإغلاق'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}