import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product_entity.dart';

class ProductDialog extends StatefulWidget {
  final ProductEntity? product;
  final int categoryId; // يجب معرفة القسم الذي سيضاف إليه المنتج

  const ProductDialog({super.key, this.product, required this.categoryId});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _barcodeController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _barcodeController = TextEditingController(text: widget.product?.barcode ?? '');
    _isActive = widget.product?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newProduct = ProductEntity(
        id: widget.product?.id ?? 0,
        categoryId: widget.categoryId,
        name: _nameController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        isActive: _isActive,
        imagePath: widget.product?.imagePath,
      );
      Navigator.of(context).pop(newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'إضافة منتج جديد' : 'تعديل المنتج'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'اسم الصنف'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'السعر', suffixText: 'ج.م'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'مطلوب';
                    if (double.tryParse(value) == null) return 'يجب إدخال رقم صحيح';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(labelText: 'الباركود السريع (اختياري)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('حالة المنتج (متوفر/غير متوفر)'),
                  value: _isActive,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _isActive = val),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}