import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_event.dart';
import '../bloc/expense/expense_state.dart';
import '../bloc/shift/shift_bloc.dart';
import '../bloc/shift/shift_event.dart';
import '../bloc/shift/shift_state.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/close_shift_dialog.dart';
import '../widgets/open_shift_dialog.dart';

class ShiftScreen extends StatefulWidget {
  const ShiftScreen({super.key});

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  @override
  void initState() {
    super.initState();
    // التحقق من حالة الوردية عند فتح الشاشة
    context.read<ShiftBloc>().add(CheckCurrentShiftEvent());
  }

  void _showOpenShiftDialog() async {
    final startingCash = await showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const OpenShiftDialog(),
    );
    if (startingCash != null && mounted) {
      context.read<ShiftBloc>().add(OpenShiftEvent(startingCash));
    }
  }

  void _showAddExpenseDialog(int shiftId) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => const AddExpenseDialog(),
    );
    if (result != null && mounted) {
      context.read<ExpenseBloc>().add(AddExpenseEvent(amount: result['amount'], reason: result['reason']));
      // إعادة تحميل الوردية لتحديث إجمالي المصروفات في واجهة لوحة التحكم
      context.read<ShiftBloc>().add(CheckCurrentShiftEvent()); 
    }
  }

  void _showCloseShiftDialog(double expectedCash) async {
    final actualCash = await showDialog<double>(
      context: context,
      builder: (ctx) => CloseShiftDialog(expectedCash: expectedCash),
    );
    if (actualCash != null && mounted) {
      context.read<ShiftBloc>().add(CloseShiftEvent(actualCash));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الوردية والمصروفات'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ShiftBloc, ShiftState>(
            listener: (context, state) {
              if (state is ShiftActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.success));
              } else if (state is ShiftError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
              }
            },
          ),
          BlocListener<ExpenseBloc, ExpenseState>(
            listener: (context, state) {
              if (state is ExpenseActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.success));
              } else if (state is ExpenseError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
              }
            },
          ),
        ],
        child: BlocBuilder<ShiftBloc, ShiftState>(
          builder: (context, state) {
            if (state is ShiftLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CurrentShiftLoaded) {
              final shift = state.shift;
              
              // حالة: لا توجد وردية مفتوحة
              if (shift == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_clock, size: 100, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('لا توجد وردية مفتوحة حالياً', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                        onPressed: _showOpenShiftDialog,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('بدء وردية جديدة', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                );
              }

              // حالة: توجد وردية مفتوحة
              // تحميل مصروفات هذه الوردية
              context.read<ExpenseBloc>().add(LoadExpensesForShiftEvent(shift.id));
              
              final expectedCash = shift.startingCash + shift.totalSales - shift.totalExpenses;

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الجانب الأيمن: لوحة تحكم الوردية
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  const Text('ملخص الوردية الحالية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const Divider(height: 32),
                                  _buildSummaryRow('العهدة الافتتاحية:', '${shift.startingCash} ج.م'),
                                  _buildSummaryRow('إجمالي المبيعات:', '${shift.totalSales} ج.م', color: AppColors.success),
                                  _buildSummaryRow('إجمالي المصروفات:', '${shift.totalExpenses} ج.م', color: AppColors.error),
                                  const Divider(height: 32),
                                  _buildSummaryRow('المتوقع في الدرج:', '$expectedCash ج.م', isBold: true),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: AppColors.error, foregroundColor: Colors.white),
                            onPressed: () => _showCloseShiftDialog(expectedCash),
                            icon: const Icon(Icons.stop_circle),
                            label: const Text('إغلاق الوردية'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // الجانب الأيسر: قائمة المصروفات
                    Expanded(
                      flex: 2,
                      child: Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              color: AppColors.background,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('المصروفات النثرية للوردية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ElevatedButton.icon(
                                    onPressed: () => _showAddExpenseDialog(shift.id),
                                    icon: const Icon(Icons.add),
                                    label: const Text('تسجيل مصروف'),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            Expanded(
                              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                                builder: (context, expenseState) {
                                  if (expenseState is ExpenseLoading) return const Center(child: CircularProgressIndicator());
                                  if (expenseState is ExpensesLoaded) {
                                    if (expenseState.expenses.isEmpty) {
                                      return const Center(child: Text('لم يتم تسجيل أي مصروفات خلال هذه الوردية'));
                                    }
                                    return ListView.separated(
                                      itemCount: expenseState.expenses.length,
                                      separatorBuilder: (_, _) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final expense = expenseState.expenses[index];
                                        return ListTile(
                                          leading: const CircleAvatar(backgroundColor: AppColors.error, child: Icon(Icons.money_off, color: Colors.white)),
                                          title: Text(expense.reason, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          subtitle: Text(expense.date.toString().substring(0, 16)), // وقت مختصر
                                          trailing: Text('${expense.amount} ج.م', style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16)),
                                        );
                                      },
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}