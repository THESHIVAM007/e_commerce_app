class Product {
  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.id,
    this.qty = 0, // Default quantity is 0
  });

  final String name;
  final String category;
  final int price;
  final String description;
  final String id;
  final String imageUrl;
  int qty; // Add qty field

  factory Product.fromFirestore(Map<String, dynamic> firestoreData) {
    return Product(
      name: firestoreData['name'] ?? '', // Default to empty string if null
      category: firestoreData['category'] ?? '', // Default to empty string if null
      id: firestoreData['id'] ?? '', // Default to empty string if null
      price: firestoreData['price'] ?? 0, // Default to 0 if null
      imageUrl: firestoreData['imageUrl'] ?? '', // Default to empty string if null
      description: firestoreData['description'] ?? '', // Default to empty string if null
      qty: firestoreData['qty'] ?? 0, // Default to 0 if null
    );
  }
}
