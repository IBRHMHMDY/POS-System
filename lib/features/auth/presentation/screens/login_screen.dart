import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/pin_pad_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _passcode = '';
  static const int _maxPasscodeLength = 10;

  void _onNumberPressed(String number) {
    if (_passcode.length < _maxPasscodeLength) {
      setState(() {
        _passcode += number;
      });
    }
  }

  void _onDeletePressed() {
    if (_passcode.isNotEmpty) {
      setState(() {
        _passcode = _passcode.substring(0, _passcode.length - 1);
      });
    }
  }

  void _onSubmitPressed() {
    if (_passcode.isNotEmpty) {
      context.read<AuthBloc>().add(LoginEvent(_passcode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
                setState(() {
                  _passcode = '';
                });
              } else if (state is AuthAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('مرحباً بك، ${state.user.name}'),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.go('/dashboard');
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Container(
                width: 450,
                padding: const EdgeInsets.all(40.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.point_of_sale_rounded, size: 80, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'تسجيل الدخول',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'أدخل رمز الدخول السري (Passcode)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    
                    // شاشة عرض الرقم السري المدخل
                    Container(
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: AppColors.primary)
                          : Text(
                              // تحويل الأرقام إلى نجوم للحماية (Masking)
                              _passcode.padRight(4, ' ').replaceAll(RegExp(r'.'), '●  ').trim(),
                              style: const TextStyle(
                                fontSize: 24,
                                color: AppColors.primary,
                                letterSpacing: 8,
                              ),
                            ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // لوحة الأرقام
                    PinPadWidget(
                      isLoading: isLoading,
                      onNumberPressed: _onNumberPressed,
                      onDeletePressed: _onDeletePressed,
                      onSubmitPressed: _onSubmitPressed,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}