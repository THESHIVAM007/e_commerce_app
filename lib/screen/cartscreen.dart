import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce_app/provider/cart_provider.dart';
import 'package:e_commerce_app/widget/addtocartbutton.dart';
import 'package:e_commerce_app/screen/checkoutpage.dart';

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
      backgroundColor: const Color.fromARGB(255, 232, 221, 221),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('My Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final cartItems = ref.watch(cartProductProvider);
          final total = cartItems.fold<double>(
              0.0, (sum, item) => sum + item.price * item.qty);
          return cartItems.isNotEmpty
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) => Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      cartItems[index].imageUrl,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItems[index].name,
                                          maxLines:
                                              1, // Ensures the text doesn't wrap to the next line
                                          overflow: TextOverflow
                                              .ellipsis, // Adds an ellipsis to texts that would overflow
                                          softWrap:
                                              true, // Prevents text from wrapping onto the next line
                                        ),
                                        Text("${cartItems[index].qty}"),
                                      ],
                                    ),
                                  ),
                                  AddToCartButton(product: cartItems[index]),
                                  const SizedBox(
                                      width:
                                          8), // Provide some spacing between the button and the price
                                  Text(
                                    "₹ ${(cartItems[index].price * cartItems[index].qty)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight
                                            .bold), // Makes the price bold
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Bill Details',
                                  style: theme.textTheme.titleLarge),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'MRP Total:',
                                  ),
                                  const Spacer(),
                                  Text("$total"),
                                ],
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Coupon Discount:',
                                  ),
                                  Spacer(),
                                  Text("-100"),
                                ],
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Handling Fee (incl GST):',
                                  ),
                                  Spacer(),
                                  Text(" -5"),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CheckoutPage(),
                                      ));
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: theme.colorScheme.primary,
                                ),
                                child: const Text('Proceed to Pay'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('No products found'));
        },
      ),
    );
  }
}
