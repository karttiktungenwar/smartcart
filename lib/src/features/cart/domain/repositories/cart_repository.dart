import '../../../product/domain/entities/product.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCart();
  Future<void> addToCart(Product product, {int quantity = 1});
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> removeFromCart(int productId);
  Future<void> clearCart();
}
