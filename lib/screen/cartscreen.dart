import 'package:e_commerce_app/provider/cart_provider.dart';
import 'package:e_commerce_app/screen/checkoutpage.dart';
import 'package:e_commerce_app/widget/addtocartbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary)),
        title: Text(
          "My Cart",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: const [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 2),
              ),
            ],
          ),
        ),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final cartItems = ref.watch(cartProductProvider);
          final total = cartItems.fold<double>(
              0.0, (sum, item) => sum + (item.price * item.qty));
          return cartItems.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white,
                            elevation: 3,
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Image.network(
                                    cartItems[index].imageUrl,
                                    fit: BoxFit.contain,
                                    height: 80,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItems[index].name,
                                          style: theme.textTheme.titleLarge,
                                        ),
                                        Text(
                                          cartItems[index].category,
                                          style: theme.textTheme.titleSmall,
                                        ),
                                        Text(
                                          cartItems[index].description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        Text(
                                          '₹ ${cartItems[index].price.toStringAsFixed(2)}',
                                          style: theme.textTheme.titleLarge,
                                        ),
                                        AddToCartButton(
                                          product: cartItems[index],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text(
                              "Cart total -",
                              style: theme.textTheme.titleLarge,
                            ),
                            const Spacer(),
                            Text("₹ $total", style: theme.textTheme.titleLarge)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            textStyle: MaterialStatePropertyAll(theme.textTheme.labelLarge),
                            backgroundColor: MaterialStatePropertyAll(theme.colorScheme.secondary),
                            foregroundColor: MaterialStatePropertyAll(theme.colorScheme.onPrimary),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const CheckoutPage(),
                            ));
                          },
                          child: const Text("Checkout"),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text("No products found"));
        },
      ),
    );
  }
}
