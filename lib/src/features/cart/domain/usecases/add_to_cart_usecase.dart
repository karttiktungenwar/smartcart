import '../../../product/domain/entities/product.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> execute(Product product, {int quantity = 1}) {
    return repository.addToCart(product, quantity: quantity);
  }
}
