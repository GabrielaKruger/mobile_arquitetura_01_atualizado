import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_imp.dart';
import 'package:product_app/main.dart';
import 'package:product_app/presentation/pages/viewmodels/product_viewmodel.dart';

void main() {
  testWidgets('exibe tela de login ao iniciar', (tester) async {
    final cache = ProductCacheDatasource();
    final remote = ProductRemoteDatasource(http.Client());
    final repository = ProductRepositoryImpl(remote, cache);
    final viewModel = ProductViewModel(repository);

    await tester.pumpWidget(MyApp(viewModel: viewModel));

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
