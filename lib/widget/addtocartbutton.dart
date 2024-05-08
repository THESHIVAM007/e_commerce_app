import 'package:e_commerce_app/model/product.dart';
import 'package:e_commerce_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToCartButton extends ConsumerStatefulWidget {
  const AddToCartButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  ConsumerState<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends ConsumerState<AddToCartButton> {


  void increment() {
    if (widget.product.qty < 5) {
      setState(() {
        ref.watch(cartProductProvider.notifier).addToCart(widget.product);

      });
    }
  }

  void decrement() {
          setState(() {
        ref.read(cartProductProvider.notifier).removeFromCart(widget.product);
      });
    
  }

  @override
  Widget build(BuildContext context) {

    return widget.product.qty > 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: decrement,
                icon: const Icon(Icons.remove),
                color: Colors.purple,
              ),
              Text(
                '${widget.product.qty}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              IconButton(
                onPressed: increment,
                icon: const Icon(Icons.add),
                color: Colors.purple,
              ),
            ],
          )
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: increment,
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
  }
}
