class BookHome {
  final int id;
  final String title;
  final String image;
  final String year;
  final int likes;
  final int stock;

  BookHome({
    required this.id,
    required this.title,
    required this.image,
    required this.year,
    required this.likes,
    required this.stock,
  });

  factory BookHome.fromJson(Map<String, dynamic> json) {
    return BookHome(
      id: json['id_pustaka'] is int ? json['id_pustaka'] : int.parse(json['id_pustaka']),
      title: json['judul_pustaka'],
      image: json['gambar_pustaka'],
      year: json['tahun'],
      likes: json['jumlah_like'] is int
          ? json['jumlah_like']
          : json['jumlah_like'] is String && json['jumlah_like'].isNotEmpty
              ? int.parse(json['jumlah_like'])
              : 0,
      stock: json['stok'] is int
          ? json['stok']
          : json['stok'] is String && json['stok'].isNotEmpty
              ? int.parse(json['stok'])
              : 0,
    );
  }

  static List<BookHome> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BookHome.fromJson(json)).toList();
  }
}