import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final http.Client client;

  AuthService(this.client);

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Usuário ou senha inválidos");
    }
  }
}