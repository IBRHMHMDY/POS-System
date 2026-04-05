import 'package:equatable/equatable.dart';

enum UserRole { owner, manager, cashier }

class User extends Equatable {
  final int id;
  final String name;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.role,
  });

  @override
  List<Object> get props => [id, name, role];
}