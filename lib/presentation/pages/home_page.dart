import 'package:flutter/material.dart';
import 'package:product_app/presentation/pages/product_page.dart';
import 'package:product_app/presentation/pages/viewmodels/product_viewmodel.dart';
import 'package:product_app/data/session/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/data/services/auth_service.dart';
import 'package:product_app/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
    final ProductViewModel viewModel;
    const HomePage({super.key, required this.viewModel});
    @override
    Widget build(BuildContext context) {
        return Scaffold(
appBar: AppBar(
  title: Text(
    "Olá, ${SessionManager.user?["firstName"]}",
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
onPressed: () {
  SessionManager.logout();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => LoginPage(
        authService: AuthService(http.Client()),
        viewModel: viewModel,
      ),
    ),
  );
},
    ),
  ],
),
            body: Center(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.pinkAccent,
                  ),
                  onPressed: () {
                    viewModel.loadProducts();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(viewModel: viewModel),
                      ),
                    );
                  },
                  label: const Text('Itens'),
                  icon: const Icon(Icons.download),
                ),
            ),
        );
    }
}