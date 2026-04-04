import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/licensing_bloc.dart';
import '../bloc/licensing_event.dart';
import '../bloc/licensing_state.dart';

class LicensingScreen extends StatefulWidget {
  const LicensingScreen({super.key});

  @override
  State<LicensingScreen> createState() => _LicensingScreenState();
}

class _LicensingScreenState extends State<LicensingScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // بمجرد فتح الشاشة، نقوم بطلب جلب معرف الجهاز وحالة الترخيص
    context.read<LicensingBloc>().add(CheckLicenseStatus());
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _copyDeviceId(BuildContext context, String deviceId) {
    Clipboard.setData(ClipboardData(text: deviceId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ مُعرّف الجهاز بنجاح.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocConsumer<LicensingBloc, LicensingState>(
            listener: (context, state) {
              if (state is LicensingFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is LicensingSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تفعيل النظام بنجاح!'),
                    backgroundColor: AppColors.success,
                  ),
                );
                // TODO: التوجيه لاحقاً إلى شاشة تسجيل الدخول (Login Screen)
              }
            },
            builder: (context, state) {
              if (state is LicensingLoading || state is LicensingInitial) {
                return const CircularProgressIndicator(color: AppColors.primary);
              }

              if (state is LicensingStatusLoaded) {
                // إذا كان النظام مفعلاً مسبقاً، لا داعي لعرض الشاشة (يمكن توجيهه لاحقاً)
                if (state.isActivated) {
                  return const Text('النظام مفعل مسبقاً. جاري التوجيه...');
                }

                return _buildActivationForm(context, state.deviceId);
              }

              // في حالة وجود خطأ وبقاء الشاشة
              return ElevatedButton(
                onPressed: () => context.read<LicensingBloc>().add(CheckLicenseStatus()),
                child: const Text('إعادة المحاولة'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActivationForm(BuildContext context, String deviceId) {
    return Container(
      width: 500, // عرض ثابت ليناسب التابلت وشاشات الويندوز بشكل أنيق
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(Icons.lock_outline, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'تفعيل نظام نقاط البيع',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'مُعرّف الجهاز (Device ID):',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SelectableText(
                    deviceId,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'Courier', // خط واضح للأكواد
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: AppColors.primary),
                  onPressed: () => _copyDeviceId(context, deviceId),
                  tooltip: 'نسخ مُعرّف الجهاز',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'كود التفعيل',
              hintText: 'أدخل كود التفعيل المكون من 10 أرقام/أحرف',
            ),
            textCapitalization: TextCapitalization.characters,
            maxLength: 10,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final code = _codeController.text.trim();
                if (code.isNotEmpty) {
                  context.read<LicensingBloc>().add(SubmitActivationCode(code));
                }
              },
              child: const Text('تفعيل النظام'),
            ),
          ),
        ],
      ),
    );
  }
}