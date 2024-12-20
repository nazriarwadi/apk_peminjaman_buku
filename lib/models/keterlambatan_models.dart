class Keterlambatan {
  final String code;
  final String title;
  final String borrowDate;
  final String dueDate;
  final String status;
  final String late;
  final String fineAmount;

  Keterlambatan({
    required this.code,
    required this.title,
    required this.borrowDate,
    required this.dueDate,
    required this.status,
    required this.late,
    required this.fineAmount,
  });

  factory Keterlambatan.fromJson(Map<String, dynamic> json) {
    return Keterlambatan(
      code: json['kode_peminjaman'] ?? '',
      title: json['judul_pustaka'] ?? '',
      borrowDate: json['tanggal_pinjam'] ?? '',
      dueDate: json['harus_kembali'] ?? '',
      status: json['status'] ?? 'Unknown',
      late: json['terlambat'] ?? '0 hari',
      fineAmount: json['perkiraan_denda'] ?? '0',
    );
  }
}
