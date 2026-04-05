import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/shift_entity.dart';
import '../../repositories/shift_repository.dart';

class GetShiftHistoryUseCase implements UseCase<List<ShiftEntity>, NoParams> {
  final ShiftRepository repository;

  GetShiftHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ShiftEntity>>> call(NoParams params) async {
    return await repository.getShiftHistory();
  }
}