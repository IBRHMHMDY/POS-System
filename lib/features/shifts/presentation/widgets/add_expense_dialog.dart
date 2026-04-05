import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final reason = _reasonController.text.trim();
      Navigator.of(context).pop({'amount': amount, 'reason': reason});
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
                Text('تسجيل مصروف نثري', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'قيمة المصروف', suffixText: 'ج.م'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value == null || value.trim().isEmpty || double.tryParse(value) == null ? 'أدخل مبلغاً صحيحاً' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(labelText: 'سبب الصرف (البيان)'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'يرجى كتابة سبب الصرف' : null,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary))),
                    const SizedBox(width: 16),
                    ElevatedButton(onPressed: _submit, child: const Text('حفظ المصروف')),
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