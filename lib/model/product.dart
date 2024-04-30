class Product{
  Product({
required this.name,
required this.category,
required this.price,
required this.description,
  });
  final String name;
  final String category;
  final int price;
  final String description;

    factory Product.fromFirestore(Map<String, dynamic> firestoreData) {
    return Product(
      name: firestoreData['name'],
      category: firestoreData['category'],
      price: firestoreData['price'],
      description: firestoreData['description'],
    );
  }
}