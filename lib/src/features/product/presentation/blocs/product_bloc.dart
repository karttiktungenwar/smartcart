import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  List<String> _cachedCategories = [];

  ProductBloc({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
    required this.getProductsByCategoryUseCase,
    required this.searchProductsUseCase,
  }) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<SearchProductsEvent>(_onSearchProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final productsFuture = getProductsUseCase.execute();
      final categoriesFuture = _cachedCategories.isEmpty
          ? getCategoriesUseCase.execute()
          : Future.value(_cachedCategories);

      final results = await Future.wait([productsFuture, categoriesFuture]);
      final products = results[0] as List<dynamic>;
      final categories = results[1] as List<String>;

      _cachedCategories = categories;

      emit(ProductLoaded(
        products: products.cast(),
        categories: categories,
        selectedCategory: 'All',
        searchQuery: '',
      ));
    } on Failure catch (failure) {
      emit(ProductError(failure.message));
    } catch (e) {
      emit(ProductError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    final String category = event.category;

    emit(ProductLoading());
    try {
      final products = category == 'All'
          ? await getProductsUseCase.execute()
          : await getProductsByCategoryUseCase.execute(category);

      emit(ProductLoaded(
        products: products,
        categories: _cachedCategories,
        selectedCategory: category,
        searchQuery: '',
      ));
    } on Failure catch (failure) {
      emit(ProductError(failure.message));
    } catch (e) {
      emit(ProductError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      add(const FetchProductsEvent());
      return;
    }

    emit(ProductLoading());
    try {
      final products = await searchProductsUseCase.execute(query);
      emit(ProductLoaded(
        products: products,
        categories: _cachedCategories,
        selectedCategory: 'All',
        searchQuery: query,
      ));
    } on Failure catch (failure) {
      emit(ProductError(failure.message));
    } catch (e) {
      emit(ProductError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    _cachedCategories = [];
    add(const FetchProductsEvent());
  }
}
