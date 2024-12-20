class AturanPustaka {
  final int waktuPeminjaman;
  final int dendaKeterlambatan;
  final int maksimalPeminjaman;

  AturanPustaka({required this.waktuPeminjaman, required this.dendaKeterlambatan, required this.maksimalPeminjaman});

  factory AturanPustaka.fromJson(Map<String, dynamic> json) {
    return AturanPustaka(
      waktuPeminjaman: int.parse(json['waktu_peminjaman']),
      dendaKeterlambatan: int.parse(json['denda_keterlambatan']),
      maksimalPeminjaman: int.parse(json['maksimal_peminjaman']),
    );
  }
}
