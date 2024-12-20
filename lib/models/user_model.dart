class RegisterRequest {
  final String name;
  final String phoneNumber;
  final String email;
  final String username;
  final String password;

  RegisterRequest({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': name,
      'nomor_telp': phoneNumber,
      'email': email,
      'username': username,
      'password': password,
    };
  }
}
