import 'package:product_app/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}