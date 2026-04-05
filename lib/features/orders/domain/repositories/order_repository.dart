import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';
import '../entities/order_item_entity.dart';

abstract class OrderRepository {
  /// إنشاء وحفظ فاتورة مبيعات جديدة مع جميع عناصرها كعملية واحدة (Transaction)
  Future<Either<Failure, OrderEntity>> createOrder({
    required OrderEntity order,
    required List<OrderItemEntity> items,
  });

  /// جلب جميع الفواتير المرتبطة بوردية معينة (مهم للمراجعة والتقارير)
  Future<Either<Failure, List<OrderEntity>>> getOrdersByShift(int shiftId);

  /// جلب تفاصيل وعناصر فاتورة معينة بناءً على رقمها
  Future<Either<Failure, List<OrderItemEntity>>> getOrderItems(int orderId);
}