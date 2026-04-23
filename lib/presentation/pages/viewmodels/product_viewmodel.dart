import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/presentation/pages/viewmodels/product_state.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state =
      ValueNotifier(const ProductState());

  ProductViewModel(this.repository);


  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);

    try {
      final products = await repository.getProducts();

      state.value = state.value.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

 
  Future<void> addProduct(Product product) async {
    await repository.addProduct(product);
    await loadProducts();
  }


  Future<void> updateProduct(Product product) async {
    await repository.updateProduct(product);
    await loadProducts();
  }


  Future<void> deleteProduct(String id) async {
    await repository.deleteProduct(id);
    await loadProducts();
  }
}