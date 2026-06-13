import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final String productName;
  final double price;
  final String description;
  final String image;
  final String category;

  const ProductDetailPage({
    super.key,
    required this.productName,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(category),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Image.network(image, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.pink),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
