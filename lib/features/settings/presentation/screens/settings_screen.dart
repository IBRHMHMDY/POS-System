import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _storeNameController;
  late TextEditingController _taxRateController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController();
    _taxRateController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();

    // جلب الإعدادات عند فتح الشاشة
    context.read<SettingsBloc>().add(LoadSettingsEvent());
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _taxRateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      context.read<SettingsBloc>().add(
        SaveSettingsEvent(
          storeName: _storeNameController.text.trim(),
          taxRate: double.tryParse(_taxRateController.text.trim()) ?? 0.0,
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات النظام'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            // تحديث الحقول بالبيانات القادمة من قاعدة البيانات
            // نتأكد من عدم تحديثها إذا كان المستخدم يكتب حالياً لتجنب مسح كتابته
            if (_storeNameController.text.isEmpty && state.storeName.isNotEmpty) {
               _storeNameController.text = state.storeName;
               _taxRateController.text = state.taxRate.toString();
               _phoneController.text = state.phone;
               _addressController.text = state.address;
            }

            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!), backgroundColor: AppColors.success),
              );
            }
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading && _storeNameController.text.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('إعدادات المتجر (تظهر على الفواتير)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _storeNameController,
                          decoration: const InputDecoration(labelText: 'اسم المتجر / النشاط', border: OutlineInputBorder()),
                          validator: (value) => value == null || value.trim().isEmpty ? 'مطلوب' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _taxRateController,
                          decoration: const InputDecoration(labelText: 'نسبة الضريبة (VAT) %', border: OutlineInputBorder(), suffixText: '%'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value == null || double.tryParse(value) == null ? 'أدخل نسبة صحيحة' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(labelText: 'العنوان', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: state is SettingsLoading ? null : _onSave,
                      icon: state is SettingsLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save),
                      label: const Text('حفظ الإعدادات', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}