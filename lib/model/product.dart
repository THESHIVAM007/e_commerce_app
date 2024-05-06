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
  final int id;
  final String imageUrl;
  int qty; // Add qty field

  factory Product.fromFirestore(Map<String, dynamic> firestoreData) {
    return Product(
      name: firestoreData['name'],
      category: firestoreData['category'],
      id: firestoreData['id'],
      price: firestoreData['price'],
      imageUrl: firestoreData['image_url'],
      description: firestoreData['description'],
      qty: firestoreData['qty'] ?? 0, // Initialize qty from Firestore, default is 0
    );
  }
}