class BookLoan {
  final String code;
  final String title;
  final String startTime;
  final String endTime;
  final String status;

  BookLoan({
    required this.code,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory BookLoan.fromJson(Map<String, dynamic> json) {
    return BookLoan(
      code: json['kode_peminjaman'],
      title: json['judul_pustaka'],
      startTime: json['tanggal_pinjam'],
      endTime: json['tanggal_kembali'],
      status: json['status'],
    );
  }
}