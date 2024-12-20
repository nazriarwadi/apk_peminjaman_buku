class UserProfile {
  late final String profileImageUrl;
  final String code;
  final String name;
  final String phoneNumber;
  final String email;
  final String birthPlace;
  final DateTime birthDate;
  final String gender;
  final String address;

  UserProfile({
    required this.profileImageUrl,
    required this.code,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.birthPlace,
    required this.birthDate,
    required this.gender,
    required this.address,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profileImageUrl: json['foto'],
      code: json['kode_anggota'].toString(), // Ensure this is a string
      name: json['nama_anggota'].toString(),
      phoneNumber: json['no_telp'].toString(), // Ensure this is a string
      email: json['email'].toString(),
      birthPlace: json['tempat_lahir'].toString(),
      birthDate: DateTime.parse(json['tanggal_lahir']),
      gender: json['jenis_kelamin'].toString(),
      address: json['alamat'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'kode_pengguna': code,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'birth_place': birthPlace,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'address': address,
      'profile_image_url': profileImageUrl,
    };
  }
}
