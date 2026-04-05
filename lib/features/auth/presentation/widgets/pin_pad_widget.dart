import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PinPadWidget extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onSubmitPressed;
  final bool isLoading;

  const PinPadWidget({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
    required this.onSubmitPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading, // تعطيل اللمس أثناء التحميل
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3'], context),
          const SizedBox(height: 16),
          _buildRow(['4', '5', '6'], context),
          const SizedBox(height: 16),
          _buildRow(['7', '8', '9'], context),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.backspace_outlined,
                color: AppColors.error,
                onPressed: onDeletePressed,
              ),
              _buildNumberButton('0', context),
              _buildActionButton(
                icon: Icons.check_circle_outline,
                color: AppColors.success,
                onPressed: onSubmitPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((num) => _buildNumberButton(num, context)).toList(),
    );
  }

  Widget _buildNumberButton(String number, BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => onNumberPressed(number),
        child: Text(
          number,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 75,
      height: 75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Icon(icon, size: 32, color: color),
      ),
    );
  }
}