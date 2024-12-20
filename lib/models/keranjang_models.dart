class CartItem {
  final String kodePustaka;
  final String judulPustaka;
  final String namaKategoriPustaka;
  final String namaPenulis;
  final String namaPenerbit;
  final String tahun;

  CartItem({
    required this.kodePustaka,
    required this.judulPustaka,
    required this.namaKategoriPustaka,
    required this.namaPenulis,
    required this.namaPenerbit,
    required this.tahun,
  });

  Map<String, dynamic> toJson() {
    return {
      'kode_pustaka': kodePustaka,
      'judul_pustaka': judulPustaka,
      'nama_kategori_pustaka': namaKategoriPustaka,
      'nama_penulis': namaPenulis,
      'nama_penerbit': namaPenerbit,
      'tahun': tahun,
    };
  }
}

