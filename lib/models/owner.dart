class Owner {
  final String id;
  String firstname;
  String secondname;
  String email;
  String phone;
  String address;
  String imageUrl;

  Owner({
    required this.id,
    required this.firstname,
    required this.secondname,
    required this.email,
    this.phone = '',
    this.address = '',
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'secondname': secondname,
      'email': email,
      'phone': phone,
      'address': address,
      'imageUrl': imageUrl,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'],
      firstname: map['firstname'],
      secondname: map['secondname'],
      email: map['email'],
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
