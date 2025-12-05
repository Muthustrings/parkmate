class User {
  final String phone;
  final String? password;
  final String name;
  final String? email;

  User({required this.phone, this.password, required this.name, this.email});

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'phone': phone, 'password': password, 'name': name, 'email': email};
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    return 'User{phone: $phone, password: $password, name: $name, email: $email}';
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      phone: map['phone'],
      password: map['password'],
      name: map['name'],
      email: map['email'],
    );
  }
}
