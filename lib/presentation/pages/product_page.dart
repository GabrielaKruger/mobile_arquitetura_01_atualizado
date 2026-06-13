import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/data/services/auth_service.dart';
import 'package:product_app/data/session/session_manager.dart';
import 'package:product_app/presentation/pages/login_page.dart';
import 'package:product_app/presentation/pages/product_detail_page.dart';
import 'package:product_app/presentation/pages/viewmodels/product_state.dart';
import 'package:product_app/presentation/pages/viewmodels/product_viewmodel.dart';
import 'package:product_app/state/riverpod/favorite_riverpod.dart';

import 'product_form_page.dart';

class ProductPage extends ConsumerWidget {
  final ProductViewModel viewModel;

  const ProductPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!SessionManager.isLogged) {
      return LoginPage(
        authService: AuthService(http.Client()),
        viewModel: viewModel,
      );
    }

    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.loadProducts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductFormPage(viewModel: viewModel),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
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

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            productName: product.title,
                            price: product.price,
                            description: product.description,
                            category: product.category,
                            image: product.image,
                          ),
                        ),
                      );
                    },
                    leading: Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                    title: Text(product.title),
                    subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductFormPage(
                                  viewModel: viewModel,
                                  product: product,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Confirmar'),
                                content: const Text(
                                  'Deseja excluir este produto?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Produto excluido com sucesso',
                                    ),
                                  ),
                                );
                              }

                              await viewModel.deleteProduct(product.id);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.purple : null,
                          ),
                          onPressed: () {
                            ref
                                .read(favoritesProvider.notifier)
                                .toggle(product.id);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                    color: Color.fromARGB(255, 136, 134, 134),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
