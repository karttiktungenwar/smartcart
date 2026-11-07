import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../product/data/models/product_model.dart';
import '../../../product/domain/entities/product.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItem(Product product, int quantity);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> removeCartItem(int productId);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box<String> box;

  CartLocalDataSourceImpl({required this.box});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final List<CartItemModel> items = [];
      for (var key in box.keys) {
        final String? jsonString = box.get(key);
        if (jsonString != null && jsonString.isNotEmpty) {
          try {
            final Map<String, dynamic> map = jsonDecode(jsonString);
            items.add(CartItemModel.fromJson(map));
          } catch (e) {
            await box.delete(key);
          }
        }
      }
      return items;
    } catch (e) {
      throw CacheException('Failed to read cart from local cache: $e');
    }
  }

  @override
  Future<void> saveCartItem(Product product, int quantity) async {
    try {
      final String key = product.id.toString();
      final String? existingJson = box.get(key);

      int newQuantity = quantity;
      if (existingJson != null) {
        try {
          final Map<String, dynamic> map = jsonDecode(existingJson);
          final currentQty = map['quantity'] as int? ?? 0;
          newQuantity += currentQty;
        } catch (_) {}
      }

      final productModel = product is ProductModel
          ? product
          : ProductModel.fromEntity(product);

      final cartItemModel = CartItemModel(
        product: productModel,
        quantity: newQuantity,
      );

      final String encodedJson = jsonEncode(cartItemModel.toJson());
      await box.put(key, encodedJson);
    } catch (e) {
      throw CacheException('Failed to save cart item to local cache: $e');
    }
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      final String key = productId.toString();
      if (quantity <= 0) {
        await box.delete(key);
        return;
      }

      final String? jsonString = box.get(key);
      if (jsonString != null) {
        final Map<String, dynamic> map = jsonDecode(jsonString);
        map['quantity'] = quantity;
        await box.put(key, jsonEncode(map));
      }
    } catch (e) {
      throw CacheException('Failed to update item quantity in cache: $e');
    }
  }

  @override
  Future<void> removeCartItem(int productId) async {
    try {
      await box.delete(productId.toString());
    } catch (e) {
      throw CacheException('Failed to remove cart item from cache: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear cart cache: $e');
    }
  }
}
