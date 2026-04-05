import 'package:equatable/equatable.dart';

enum UserRole { owner, manager, cashier }

class UserEntity extends Equatable {
  final int id;
  final String name;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.role,
  });

  @override
  List<Object> get props => [id, name, role];
}