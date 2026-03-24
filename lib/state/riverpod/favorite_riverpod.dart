import 'package:flutter_riverpod/flutter_riverpod.dart';
 
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
 
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});
 
  void toggle(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }
}