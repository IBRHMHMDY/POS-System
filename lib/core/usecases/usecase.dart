import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// واجهة قياسية (Contract) لجميع الـ UseCases.
/// [T] يمثل نوع البيانات العائدة في حالة النجاح.
/// [Params] يمثل المعاملات المطلوبة لتنفيذ العملية.
abstract class UseCase<T, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// كلاس مساعد يستخدم عندما لا يتطلب الـ UseCase أي معاملات.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}