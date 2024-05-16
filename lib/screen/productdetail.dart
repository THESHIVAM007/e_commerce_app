import 'package:e_commerce_app/model/product.dart';
import 'package:e_commerce_app/widget/addtocartbutton.dart';
import 'package:flutter/material.dart';

class ProductDetalPage extends StatefulWidget {
  const ProductDetalPage({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetalPage> createState() => _ProductDetalPageState();
}

class _ProductDetalPageState extends State<ProductDetalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: [
                  Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.contain,
                  ),
                  const Text('Brand'),
                  Text(widget.product.name),
                  Row(
                    children: [
                      Text("${widget.product.price}"),
                      Expanded(child: AddToCartButton(product: widget.product))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
