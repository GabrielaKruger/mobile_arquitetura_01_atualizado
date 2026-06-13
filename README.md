# mobile_arquitetura_01

Projeto Flutter mobile com login autenticado pela API DummyJSON, listagem de produtos, detalhes, favoritos e controle de sessao.

## Como executar

```bash
flutter pub get
flutter run
```

## API utilizada

- Login: `POST https://dummyjson.com/auth/login`
- Produtos: `GET https://dummyjson.com/products`

Usuario de teste da DummyJSON:

- Usuario: `emilys`
- Senha: `emilyspass`

## Organizacao

O projeto esta separado em camadas:

- `core`: erros e estruturas compartilhadas.
- `data`: datasources, models, repositories, services e sessao.
- `domain`: entidades e contratos.
- `presentation`: telas e viewmodels.
- `state`: estado global de favoritos com Riverpod.

## Gerenciamento de estado

O projeto usa Riverpod no controle de favoritos, porque a lista precisa atualizar automaticamente quando um produto e marcado ou removido dos favoritos. Tambem usa `ValueNotifier` no `ProductViewModel` para refletir carregamento, erro e lista de produtos, alem de `setState` na tela de login para controlar o carregamento local do botao.
