import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final int categoryId;
  final String name;
  final double price;
  final String? barcode;
  final String? imagePath;
  final bool isActive;

  const ProductEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    this.barcode,
    this.imagePath,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        price,
        barcode,
        imagePath,
        isActive,
      ];
}