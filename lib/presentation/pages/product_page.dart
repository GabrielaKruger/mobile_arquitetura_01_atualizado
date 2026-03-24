import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/presentation/pages/viewmodels/product_state.dart';
import 'package:product_app/presentation/pages/viewmodels/product_viewmodel.dart';
import 'package:product_app/state/riverpod/favorite_riverpod.dart';

class ProductPage extends ConsumerWidget {
  final ProductViewModel viewModel;
  const ProductPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.products.isEmpty) {
            return const Center(child: Text('Nenhum produto carregado.'));
          }

          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              final isFavorite = favorites.contains(product.id);

              return ListTile(
                leading: Image.network(
                  product.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image),
                ),
                title: Text(product.title),
                subtitle: Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                ),
                trailing: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  tooltip: isFavorite
                      ? 'Remover dos favoritos'
                      : 'Adicionar aos favoritos',
                  onPressed: () {
                    ref
                        .read(favoritesProvider.notifier)
                        .toggle(product.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.loadProducts,
        tooltip: 'Carregar produtos',
        child: const Icon(Icons.download),
      ),
    );
  }
}