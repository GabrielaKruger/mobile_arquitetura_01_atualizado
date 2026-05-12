import 'package:flutter/material.dart';
import 'package:product_app/data/services/auth_service.dart';
import 'package:product_app/data/session/session_manager.dart';
import 'package:product_app/presentation/pages/home_page.dart';
import 'package:product_app/presentation/pages/viewmodels/product_viewmodel.dart';

class LoginPage extends StatefulWidget {
  final AuthService authService;
  final ProductViewModel viewModel;

  const LoginPage({
    super.key,
    required this.authService,
    required this.viewModel,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (userController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha usuário e senha"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await widget.authService.login(
        username: userController.text,
        password: passwordController.text,
      );

      SessionManager.saveUser(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            viewModel: widget.viewModel,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: "Usuário",
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}