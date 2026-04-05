import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class OpenShiftDialog extends StatefulWidget {
  const OpenShiftDialog({super.key});

  @override
  State<OpenShiftDialog> createState() => _OpenShiftDialogState();
}

class _OpenShiftDialogState extends State<OpenShiftDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cashController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final startingCash = double.tryParse(_cashController.text.trim()) ?? 0.0;
      Navigator.of(context).pop(startingCash);
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
                Text('فتح وردية جديدة', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _cashController,
                  decoration: const InputDecoration(labelText: 'العهدة الافتتاحية (في الدرج)', suffixText: 'ج.م'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'يرجى إدخال المبلغ';
                    if (double.tryParse(value) == null) return 'يجب إدخال رقم صحيح';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary))),
                    const SizedBox(width: 16),
                    ElevatedButton(onPressed: _submit, child: const Text('بدء الوردية')),
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