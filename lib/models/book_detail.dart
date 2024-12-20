class BookDetail {
  final int id;
  final String kode;
  final String title;
  final int kategori;
  final String penerbit;
  final String penulis;
  final String tahun;
  final String image;
  final int halaman;
  final String dimensi;
  final int stok;
  final String rak;
  final String filePdf;
  final int jumlahLike;

  BookDetail({
    required this.id,
    required this.kode,
    required this.title,
    required this.kategori,
    required this.penerbit,
    required this.penulis,
    required this.tahun,
    required this.image,
    required this.halaman,
    required this.dimensi,
    required this.stok,
    required this.rak,
    required this.filePdf,
    required this.jumlahLike,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return BookDetail(
      id: json['id_pustaka'],
      kode: json['kode_pustaka'],
      title: json['judul_pustaka'],
      kategori: json['kategori_pustaka'],
      penerbit: json['penerbit'].toString(),
      penulis: json['penulis'].toString(),
      tahun: json['tahun'],
      image: json['gambar_pustaka'],
      halaman: json['halaman'],
      dimensi: json['dimensi'],
      stok: json['stok'],
      rak: json['rak'],
      filePdf: json['file_pdf'],
      jumlahLike: json['jumlah_like'] is String ? int.parse(json['jumlah_like']) : json['jumlah_like'],
    );
  }

  static List<BookDetail> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BookDetail.fromJson(json)).toList();
  }
}

