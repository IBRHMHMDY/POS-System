import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String? imagePath;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.imagePath,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, imagePath, isActive];
}