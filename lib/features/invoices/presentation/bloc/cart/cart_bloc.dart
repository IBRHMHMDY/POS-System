import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../../domain/entities/invoice_item_entity.dart';
import '../../../domain/usecases/create_invoice_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CreateInvoiceUseCase createInvoiceUseCase;

  CartBloc({required this.createInvoiceUseCase}) : super(const CartState()) {
    on<AddProductToCartEvent>(_onAddProduct);
    on<RemoveProductFromCartEvent>(_onRemoveProduct);
    on<UpdateCartItemQuantityEvent>(_onUpdateQuantity);
    on<ApplyDiscountEvent>(_onApplyDiscount);
    on<ApplyTaxEvent>(_onApplyTax);
    on<ClearCartEvent>(_onClearCart);
    on<CheckoutCartEvent>(_onCheckoutCart);
  }

  void _onAddProduct(AddProductToCartEvent event, Emitter<CartState> emit) {
    final List<CartItem> newItems = List.from(state.items);
    final index = newItems.indexWhere((item) => item.product.id == event.product.id);

    // إذا كان المنتج موجوداً نزيد الكمية، وإلا نضيفه جديداً
    if (index >= 0) {
      newItems[index] = newItems[index].copyWith(quantity: newItems[index].quantity + 1);
    } else {
      newItems.add(CartItem(product: event.product, quantity: 1));
    }

    _emitUpdatedCart(emit, newItems, state.discount, state.tax);
  }

  void _onRemoveProduct(RemoveProductFromCartEvent event, Emitter<CartState> emit) {
    final newItems = state.items.where((item) => item.product.id != event.productId).toList();
    _emitUpdatedCart(emit, newItems, state.discount, state.tax);
  }

  void _onUpdateQuantity(UpdateCartItemQuantityEvent event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveProductFromCartEvent(event.productId));
      return;
    }

    final List<CartItem> newItems = List.from(state.items);
    final index = newItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      newItems[index] = newItems[index].copyWith(quantity: event.quantity);
      _emitUpdatedCart(emit, newItems, state.discount, state.tax);
    }
  }

  void _onApplyDiscount(ApplyDiscountEvent event, Emitter<CartState> emit) {
    _emitUpdatedCart(emit, state.items, event.discount, state.tax);
  }

  void _onApplyTax(ApplyTaxEvent event, Emitter<CartState> emit) {
    _emitUpdatedCart(emit, state.items, state.discount, event.tax);
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    // إرجاع السلة للحالة المبدئية الصفرية
    emit(const CartState(status: CartStatus.updated, clearMessage: true));
  }

  Future<void> _onCheckoutCart(CheckoutCartEvent event, Emitter<CartState> emit) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(status: CartStatus.error, message: 'السلة فارغة، لا يمكن إتمام البيع', clearMessage: false));
      emit(state.copyWith(status: CartStatus.updated, clearMessage: true));
      return;
    }

    emit(state.copyWith(status: CartStatus.loading, clearMessage: true));

    // 1. تحويل عناصر السلة (CartItem) إلى الكيان النقي (InvoiceItemEntity)
    final invoiceItems = state.items.map((cartItem) => InvoiceItemEntity(
      id: 0,
      productId: cartItem.product.id,
      quantity: cartItem.quantity,
      unitPrice: cartItem.product.price,
      totalPrice: cartItem.totalPrice,
    )).toList();

    // 2. تجهيز الفاتورة الأساسية
    final invoice = InvoiceEntity(
      id: 0,
      shiftId: event.shiftId,
      userId: event.userId,
      subTotal: state.subTotal,
      discount: state.discount,
      tax: state.tax,
      grandTotal: state.grandTotal,
      paymentMethod: event.paymentMethod,
      date: DateTime.now(),
    );

    // 3. الحفظ في قاعدة البيانات عبر الـ UseCase
    final result = await createInvoiceUseCase(CreateInvoiceParams(invoice: invoice, items: invoiceItems));

    result.fold(
      (failure) {
        emit(state.copyWith(status: CartStatus.error, message: failure.message));
        emit(state.copyWith(status: CartStatus.updated, clearMessage: true));
      },
      (savedInvoice) {
        emit(state.copyWith(status: CartStatus.checkoutSuccess, message: 'تم حفظ الفاتورة بنجاح'));
        // إفراغ السلة تلقائياً بعد البيع استعداداً للزبون التالي
        emit(const CartState(status: CartStatus.initial));
      },
    );
  }

  // دالة مساعدة مركزية لحساب كافة الإجماليات بشكل لحظي
  void _emitUpdatedCart(Emitter<CartState> emit, List<CartItem> items, double discount, double tax) {
    double subTotal = items.fold(0, (sum, item) => sum + item.totalPrice);
    double grandTotal = subTotal + tax - discount;
    if (grandTotal < 0) grandTotal = 0; // حماية من القيم السالبة

    emit(state.copyWith(
      status: CartStatus.updated,
      items: items,
      subTotal: subTotal,
      discount: discount,
      tax: tax,
      grandTotal: grandTotal,
      clearMessage: true, // مسح أي رسائل خطأ سابقة بمجرد تحديث السلة
    ));
  }
}