import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({required this.items});

  double get subtotal => items.fold(
        0.0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get totalAmount => items.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

  double get totalSavings => subtotal - totalAmount;

  int get itemCount => items.fold(
        0,
        (sum, item) => sum + item.quantity,
      );

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
