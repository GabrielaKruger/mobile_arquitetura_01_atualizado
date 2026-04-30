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

    final p = widget.product;

    titleController = TextEditingController(text: p?.title ?? '');
    priceController = TextEditingController(text: p?.price.toString() ?? '');
    descriptionController = TextEditingController(text: p?.description ?? '');
    imageController = TextEditingController(text: p?.image ?? '');
    categoryController = TextEditingController(text: p?.category ?? '');
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    final isEdit = widget.product != null;

    final product = Product(
      id:
          widget.product?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEdit
              ? "Produto atualizado com sucesso"
              : "Produto criado com sucesso",
        ),
      ),
    );

    Navigator.pop(context);
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
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o preço';
                  if (double.tryParse(v) == null)
                    return 'Preço inválido, informe um valor numérico e separado por ponto (ex: 19.99)';
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
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
