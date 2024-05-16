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
      ref.read(cartProductProvider.notifier).addToCart(widget.product);
    }
  }

  void decrement() {
    if (widget.product.qty > 0) {
      ref.read(cartProductProvider.notifier).removeFromCart(widget.product);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return widget.product.qty > 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: decrement,
                icon: const Icon(Icons.remove),
                color: theme.colorScheme.primary,
              ),
              Text(
                '${widget.product.qty}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              IconButton(
                onPressed: increment,
                icon: const Icon(Icons.add),
                color: theme.colorScheme.primary,
              ),
            ],
          )
        : SizedBox(
          width: double.maxFinite,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary, // use secondary color or another color that fits your theme
                foregroundColor: Colors.white, // Text color on button
              ),
              onPressed: increment,
              child: const Text('Add to Cart'),
            ),
          );
  }
}
