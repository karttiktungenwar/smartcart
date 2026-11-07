import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> execute({int limit = 30, int skip = 0}) {
    return repository.getProducts(limit: limit, skip: skip);
  }
}
