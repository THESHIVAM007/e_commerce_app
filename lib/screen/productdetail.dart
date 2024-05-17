import 'package:e_commerce_app/model/product.dart';
import 'package:e_commerce_app/provider/cart_provider.dart';
import 'package:e_commerce_app/widget/addtocartbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final productQuantity = ref.read(cartProductProvider).firstWhere(
        (p) => p.id == widget.product.id,
        orElse: () => widget.product).qty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name, style: theme.textTheme.titleLarge),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.contain,
                    height: 300, // Adjust based on your layout
                    width: double.infinity,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${widget.product.price}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.product.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                   Text('Quantity in cart: $productQuantity'),
                  const SizedBox(height: 20),
                  AddToCartButton(product: widget.product)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
