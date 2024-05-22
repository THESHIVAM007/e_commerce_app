import 'package:e_commerce_app/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartProductNotifier extends StateNotifier<List<Product>> {
  CartProductNotifier() : super([]);

  void addToCart(Product product) {
    if (state.contains(product)) {
      product.qty++;
      print("Productqtyyyy ${product.qty}");
    } else {
      state.add(product);
      product.qty++;
    }
    state = List.from(state);  // This ensures the list updates and notifies listeners.
  }

  void removeFromCart(Product product) {
    if (product.qty == 1) {
      product.qty--;
      state.remove(product);
    } else if (product.qty > 1) {
      product.qty--;
      print(product.qty);
    }
    state = List.from(state);  // This ensures the list updates and notifies listeners.
  }
  void emptyCart(){
    state = [];
  }


}

// Provider for the cart product notifier
final cartProductProvider =
    StateNotifierProvider<CartProductNotifier, List<Product>>((ref) {
  return CartProductNotifier();
});
