import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/category_entity.dart';

class CategoryDialog extends StatefulWidget {
  final CategoryEntity? category; // إذا كانت null فهذا يعني "إضافة"، وإذا كانت موجودة يعني "تعديل"

  const CategoryDialog({super.key, this.category});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _isActive = widget.category?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newCategory = CategoryEntity(
        id: widget.category?.id ?? 0, // 0 للإضافة الجديدة (Drift سيولد الآيدي)
        name: _nameController.text.trim(),
        isActive: _isActive,
        imagePath: widget.category?.imagePath, // TODO: إضافة رفع الصور لاحقاً
      );
      Navigator.of(context).pop(newCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'إضافة قسم جديد' : 'تعديل القسم'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'اسم القسم'),
              validator: (value) => value == null || value.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('حالة القسم (نشط/غير نشط)'),
              value: _isActive,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _isActive = val),
            ),
          ],
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