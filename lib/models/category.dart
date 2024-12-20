class Category {
  final int id;
  final String kode;
  final String name;
  final String gambar;

  Category({required this.id, required this.kode, required this.name, required this.gambar});

  factory Category.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic id) {
      try {
        return int.parse(id.toString());
      } catch (e) {
        throw FormatException('Invalid ID format: $id');
      }
    }

    return Category(
      id: parseId(json['id_kategori_pustaka']),
      kode: json['kode_kategori_pustaka'],
      name: json['nama_kategori_pustaka'],
      gambar: json['gambar_kategori_pustaka'],
    );
  }
}
