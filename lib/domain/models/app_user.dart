class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.petName,
  });

  final String name;
  final String email;
  final String petName;

  AppUser copyWith({String? name, String? email, String? petName}) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      petName: petName ?? this.petName,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'email': email, 'petName': petName};
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      petName: json['petName'] as String? ?? '',
    );
  }
}
