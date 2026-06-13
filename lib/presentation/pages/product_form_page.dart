import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/pages/viewmodels/product_viewmodel.dart';

class ProductFormPage extends StatefulWidget {
  final ProductViewModel viewModel;
  final Product? product;

  const ProductFormPage({super.key, required this.viewModel, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    titleController = TextEditingController(text: product?.title ?? '');
    priceController = TextEditingController(text: product?.price.toString() ?? '');
    descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    imageController = TextEditingController(text: product?.image ?? '');
    categoryController = TextEditingController(text: product?.category ?? '');
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final isEdit = widget.product != null;

    final product = Product(
      id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      image: imageController.text,
      category: categoryController.text,
    );

    if (isEdit) {
      await widget.viewModel.updateProduct(product);
    } else {
      await widget.viewModel.addProduct(product);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEdit
              ? 'Produto atualizado com sucesso'
              : 'Produto criado com sucesso',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Cadastrar Produto' : 'Editar Produto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titulo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o titulo' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Preco'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o preco';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Preco invalido. Use ponto. Ex: 19.99';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descricao'),
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'URL da imagem'),
              ),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: submit, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
