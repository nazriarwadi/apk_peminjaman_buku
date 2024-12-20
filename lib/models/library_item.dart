class LibraryItem {
  final int id;
  final String imageUrl;
  final String title;
  final String year;
  final int likes;

  LibraryItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.year,
    required this.likes,
  });

  factory LibraryItem.fromJson(Map<String, dynamic> json) {
    return LibraryItem(
      id: json['id_pustaka'] is String ? int.parse(json['id_pustaka']) : json['id_pustaka'],
      imageUrl: json['gambar_pustaka'] ?? '',
      title: json['judul_pustaka'] ?? '',
      year: json['tahun'] ?? '',
      likes: json['jumlah_like'] is String ? int.parse(json['jumlah_like']) : json['jumlah_like'],
    );
  }
}
