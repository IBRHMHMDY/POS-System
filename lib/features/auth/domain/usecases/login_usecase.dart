import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

// [Type] هو User، و [Params] هو String يمثل رمز الدخول (Passcode)
class LoginUseCase implements UseCase<User, String> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(String params) async {
    return await repository.login(params);
  }
}