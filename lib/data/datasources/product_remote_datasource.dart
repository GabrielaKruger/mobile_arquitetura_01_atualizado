import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_app/data/models/product_model.dart';

class ProductRemoteDatasource {
  final http.Client client;

  ProductRemoteDatasource(this.client);

  final String baseUrl = 'https://fakestoreapi.com/products';

  // ✅ GET
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }

  // ✅ POST
  Future<void> addProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": product.title,
        "price": product.price,
        "description": product.description,
        "image": product.image,
        "category": product.category,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao adicionar produto');
    }
  }

  // ✅ PUT
  Future<void> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": product.title,
        "price": product.price,
        "description": product.description,
        "image": product.image,
        "category": product.category,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar produto');
    }
  }

  // ✅ DELETE
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar produto');
    }
  }
}