import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/domain/usecases/get_cart_usecase.dart';
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import '../../features/cart/presentation/blocs/cart_bloc.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_categories_usecase.dart';
import '../../features/product/domain/usecases/get_products_by_category_usecase.dart';
import '../../features/product/domain/usecases/get_products_usecase.dart';
import '../../features/product/domain/usecases/search_products_usecase.dart';
import '../../features/product/presentation/blocs/product_bloc.dart';

class ServiceLocator {
  static late final http.Client httpClient;
  static late final Box<String> cartBox;

  static late final ProductRemoteDataSource productRemoteDataSource;
  static late final CartLocalDataSource cartLocalDataSource;

  static late final ProductRepository productRepository;
  static late final CartRepository cartRepository;

  static late final GetProductsUseCase getProductsUseCase;
  static late final GetCategoriesUseCase getCategoriesUseCase;
  static late final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  static late final SearchProductsUseCase searchProductsUseCase;

  static late final GetCartUseCase getCartUseCase;
  static late final AddToCartUseCase addToCartUseCase;
  static late final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  static late final RemoveFromCartUseCase removeFromCartUseCase;
  static late final ClearCartUseCase clearCartUseCase;

  static Future<void> init() async {
    // 1. Initialize Hive Flutter & open JSON box
    await Hive.initFlutter();
    cartBox = await Hive.openBox<String>('cart_json_box');

    // 2. HTTP Client
    httpClient = http.Client();

    // 3. Data Sources
    productRemoteDataSource = ProductRemoteDataSourceImpl(client: httpClient);
    cartLocalDataSource = CartLocalDataSourceImpl(box: cartBox);

    // 4. Repositories
    productRepository = ProductRepositoryImpl(remoteDataSource: productRemoteDataSource);
    cartRepository = CartRepositoryImpl(localDataSource: cartLocalDataSource);

    // 5. Use Cases - Product
    getProductsUseCase = GetProductsUseCase(productRepository);
    getCategoriesUseCase = GetCategoriesUseCase(productRepository);
    getProductsByCategoryUseCase = GetProductsByCategoryUseCase(productRepository);
    searchProductsUseCase = SearchProductsUseCase(productRepository);

    // 5. Use Cases - Cart
    getCartUseCase = GetCartUseCase(cartRepository);
    addToCartUseCase = AddToCartUseCase(cartRepository);
    updateCartQuantityUseCase = UpdateCartQuantityUseCase(cartRepository);
    removeFromCartUseCase = RemoveFromCartUseCase(cartRepository);
    clearCartUseCase = ClearCartUseCase(cartRepository);
  }

  static ProductBloc createProductBloc() {
    return ProductBloc(
      getProductsUseCase: getProductsUseCase,
      getCategoriesUseCase: getCategoriesUseCase,
      getProductsByCategoryUseCase: getProductsByCategoryUseCase,
      searchProductsUseCase: searchProductsUseCase,
    );
  }

  static CartBloc createCartBloc() {
    return CartBloc(
      getCartUseCase: getCartUseCase,
      addToCartUseCase: addToCartUseCase,
      updateCartQuantityUseCase: updateCartQuantityUseCase,
      removeFromCartUseCase: removeFromCartUseCase,
      clearCartUseCase: clearCartUseCase,
    );
  }
}
