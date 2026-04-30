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

 
  final List<ProductModel> _localProducts = [];

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();

      // junta API + locais
      final allProducts = [...models, ..._localProducts];

      return allProducts.map((m) => Product(
            id: m.id.toString(),
            title: m.title,
            description: m.description,
            price: m.price,
            image: m.image,
            category: m.category,
          )).toList();
    } catch (e) {
      throw Failure("Erro ao carregar produtos");
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

    _localProducts.add(model);
  }

 
  @override
  Future<void> updateProduct(Product product) async {
    final index = _localProducts.indexWhere(
      (p) => p.id.toString() == product.id,
    );

    if (index != -1) {
      _localProducts[index] = ProductModel(
        id: int.parse(product.id),
        title: product.title,
        description: product.description,
        price: product.price,
        image: product.image,
        category: product.category,
      );
    }
  }

 
  @override
  Future<void> deleteProduct(String id) async {
    _localProducts.removeWhere((p) => p.id.toString() == id);
  }
}