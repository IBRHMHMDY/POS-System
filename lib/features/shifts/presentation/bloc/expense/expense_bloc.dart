import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/expenses/add_expense_usecase.dart';
import '../../../domain/usecases/expenses/get_expenses_for_shift_usecase.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpenseUseCase addExpenseUseCase;
  final GetExpensesForShiftUseCase getExpensesForShiftUseCase;

  ExpenseBloc({
    required this.addExpenseUseCase,
    required this.getExpensesForShiftUseCase,
  }) : super(ExpenseInitial()) {
    on<AddExpenseEvent>(_onAddExpense);
    on<LoadExpensesForShiftEvent>(_onLoadExpensesForShift);
  }

  Future<void> _onAddExpense(AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    final result = await addExpenseUseCase(AddExpenseParams(amount: event.amount, reason: event.reason));
    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expense) {
        emit(const ExpenseActionSuccess('تم تسجيل المصروف بنجاح'));
        if (expense.shiftId != null) {
          add(LoadExpensesForShiftEvent(expense.shiftId!)); // تحديث القائمة تلقائياً
        }
      },
    );
  }

  Future<void> _onLoadExpensesForShift(LoadExpensesForShiftEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    final result = await getExpensesForShiftUseCase(event.shiftId);
    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expenses) => emit(ExpensesLoaded(expenses)),
    );
  }
}