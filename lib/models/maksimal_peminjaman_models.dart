// models/maksimal_peminjaman.dart
class MaksimalPeminjaman {
  final int maksimalPeminjaman;
  final String namaAnggota;

  MaksimalPeminjaman({
    required this.maksimalPeminjaman,
    required this.namaAnggota,
  });

  factory MaksimalPeminjaman.fromJson(Map<String, dynamic> json) {
    return MaksimalPeminjaman(
      maksimalPeminjaman: json['maksimal_peminjaman'],
      namaAnggota: json['nama_anggota'],
    );
  }
}
