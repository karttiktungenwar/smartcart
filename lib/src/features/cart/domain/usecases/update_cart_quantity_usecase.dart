import '../repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<void> execute(int productId, int quantity) {
    return repository.updateQuantity(productId, quantity);
  }
}
