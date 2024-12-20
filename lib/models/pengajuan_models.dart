class BorrowSuccess {
  final String kodePeminjaman;
  final String namaAnggota;
  final String tanggal;
  final List<Book> books;

  BorrowSuccess({
    required this.kodePeminjaman,
    required this.namaAnggota,
    required this.tanggal,
    required this.books,
  });

  factory BorrowSuccess.fromJson(Map<String, dynamic> json) {
    return BorrowSuccess(
      kodePeminjaman: json['kode_peminjaman'] ?? '',
      namaAnggota: json['nama_anggota'] ?? '',
      tanggal: json['tanggal'] ?? '',
      books: (json['books'] as List<dynamic>?)
              ?.map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// models/book.dart
class Book {
  final String title;
  final String image;

  Book({
    required this.title,
    required this.image,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['judul_pustaka'] ?? '',
      image: json['gambar_pustaka'] ?? '',
    );
  }

  static List<Book> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Book.fromJson(json)).toList();
  }
}
