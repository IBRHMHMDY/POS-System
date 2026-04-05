import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pos_system/features/reports/presentation/bloc/report_bloc.dart';
import 'package:pos_system/features/reports/presentation/bloc/report_event.dart';
import 'package:pos_system/features/reports/presentation/bloc/report_state.dart';
import '../../../../core/theme/app_theme.dart';


class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // تعيين التاريخ الافتراضي ليكون اليوم الحالي (من بداية اليوم لنهايته)
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // طلب التقرير فور فتح الشاشة
    _loadReport();
  }

  void _loadReport() {
    context.read<ReportBloc>().add(LoadReportSummaryEvent(
          startDate: _startDate,
          endDate: _endDate,
        ));
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        // جعل نهاية الفترة تغطي اليوم الأخير بالكامل (الساعة 23:59:59)
        _endDate = DateTime(picked.end.year, picked.end.month, picked.end.day, 23, 59, 59);
      });
      _loadReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'en_US');

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير المالية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // شريط اختيار التاريخ
          Container(
            padding: const EdgeInsets.all(16.0),
            color: AppColors.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'الفترة: ${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectDateRange(context),
                  icon: const Icon(Icons.date_range),
                  label: const Text('تغيير الفترة'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // لوحة عرض الأرقام
          Expanded(
            child: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is ReportLoading || state is ReportInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ReportError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: AppColors.error, fontSize: 16)),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _loadReport, child: const Text('إعادة المحاولة')),
                      ],
                    ),
                  );
                } else if (state is ReportLoaded) {
                  final summary = state.reportSummary;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // بطاقة صافي الدخل (الأهم، نضعها في الأعلى وتكون بارزة)
                        _buildMainCard(
                          title: 'صافي الدخل (الأرباح)',
                          value: summary.netIncome,
                          icon: Icons.account_balance_wallet,
                          color: summary.netIncome >= 0 ? AppColors.success : AppColors.error,
                        ),
                        const SizedBox(height: 24),

                        // باقي التفاصيل في شبكة (Grid)
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.5,
                          children: [
                            _buildInfoCard('إجمالي المبيعات', summary.totalSales, Icons.point_of_sale, AppColors.primary),
                            _buildInfoCard('إجمالي المصروفات', summary.totalExpenses, Icons.money_off, AppColors.error),
                            _buildInfoCard('الخصومات الممنوحة', summary.totalDiscounts, Icons.discount, Colors.orange),
                            _buildInfoCard('الضرائب المحصلة', summary.totalTaxes, Icons.request_quote, Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة بارزة لصافي الدخل
  Widget _buildMainCard({required String title, required double value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(icon, size: 60, color: color),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(2)} ج.م',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  // بطاقات التفاصيل الفرعية
  Widget _buildInfoCard(String title, double value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${value.toStringAsFixed(2)} ج', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}