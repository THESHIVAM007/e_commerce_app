import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/model/product.dart';
import 'package:e_commerce_app/screen/productdetail.dart';
import 'package:e_commerce_app/widget/addtocartbutton.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailPage(product: widget.product),));
      },
      child: Container(
        decoration: BoxDecoration(
        color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 210, 206, 206))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Important to manage size properly
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: 
                  widget.product.imageUrl,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
                  key: UniqueKey(),
                  fit: BoxFit.cover,
                  height: 150,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.product.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '₹${widget.product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AddToCartButton(product: widget.product),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
