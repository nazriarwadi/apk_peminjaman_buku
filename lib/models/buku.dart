class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id_kategori_pustaka'].toString(),
      name: json['nama_kategori_pustaka'] ?? 'Unknown',
    );
  }
}

class Author {
  final String id;
  final String name;

  Author({required this.id, required this.name});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id_penulis'].toString(),
      name: json['nama_penulis'] ?? 'Unknown',
    );
  }
}

class Publisher {
  final String id;
  final String name;

  Publisher({required this.id, required this.name});

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id_penerbit'].toString(),
      name: json['nama_penerbit'] ?? 'Unknown',
    );
  }
}
