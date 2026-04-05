import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/shift_entity.dart';
import '../../repositories/shift_repository.dart';

class GetCurrentActiveShiftUseCase implements UseCase<ShiftEntity?, NoParams> {
  final ShiftRepository repository;

  GetCurrentActiveShiftUseCase(this.repository);

  @override
  Future<Either<Failure, ShiftEntity?>> call(NoParams params) async {
    return await repository.getCurrentActiveShift();
  }
}