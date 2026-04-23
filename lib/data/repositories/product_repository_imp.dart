import 'package:product_app/core/errors/failure.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/models/product_model.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);


  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();

      cache.save(models);

      return models.map((m) => Product(
            id: m.id.toString(),
            title: m.title,
            description: m.description,
            price: m.price,
            image: m.image,
            category: m.category,
          )).toList();
    } catch (e) {
      final cached = cache.get();

      if (cached != null) {
        return cached.map((m) => Product(
              id: m.id.toString(),
              title: m.title,
              description: m.description,
              price: m.price,
              image: m.image,
              category: m.category,
            )).toList();
      }

      throw Failure("Não foi possível carregar os produtos");
    }
  }

 
  @override
  Future<void> addProduct(Product product) async {
    final model = ProductModel(
      id: int.parse(product.id),
      title: product.title,
      description: product.description,
      price: product.price,
      image: product.image,
      category: product.category,
    );

    await remote.addProduct(model);
  }

 
  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel(
      id: int.parse(product.id),
      title: product.title,
      description: product.description,
      price: product.price,
      image: product.image,
      category: product.category,
    );

    await remote.updateProduct(model);
  }


  @override
  Future<void> deleteProduct(String id) async {
    await remote.deleteProduct(id);
  }
}