class FineDetail {
  final String code;
  final String title;
  final String date;
  final String type;
  final String amount;

  FineDetail({
    required this.code,
    required this.title,
    required this.date,
    required this.type,
    required this.amount,
  });

  factory FineDetail.fromJson(Map<String, dynamic> json) {
    return FineDetail(
      code: json['kode_peminjaman'] ?? '',
      title: json['judul_pustaka'] ?? '',
      date: json['tanggal_pinjam'] ?? '',
      type: json['jenis_denda'] ?? 'Unknown',
      amount: json['denda'] ?? '0',
    );
  }
}
