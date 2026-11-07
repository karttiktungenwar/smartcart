import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CartItem>> getCart() async {
    try {
      return await localDataSource.getCartItems();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      await localDataSource.saveCartItem(product, quantity);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      await localDataSource.updateQuantity(productId, quantity);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    try {
      await localDataSource.removeCartItem(productId);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await localDataSource.clearCart();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }
}
