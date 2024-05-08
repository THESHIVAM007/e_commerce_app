class UserModel {
  final String uid;
  final String fullName;
  final String address;
  final String phoneNumber;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
  });

  // Converts a Firestore DocumentSnapshot to a UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> doc) {
    return UserModel(
      uid: doc['uid'] as String,
      fullName: doc['fullName'] as String,
      address: doc['address'] as String,
      phoneNumber: doc['phoneNumber'] as String,
    );
  }

  // Converts a UserModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }
}
