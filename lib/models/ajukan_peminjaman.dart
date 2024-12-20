class BorrowRequest {
  final String kodePengguna;
  final List<Map<String, String>> cartPustaka;

  BorrowRequest({
    required this.kodePengguna,
    required this.cartPustaka,
  });

  Map<String, dynamic> toJson() {
    return {
      'kode_pengguna': kodePengguna,
      'cart_pustaka': cartPustaka,
    };
  }
}
