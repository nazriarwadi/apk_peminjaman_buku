class Config {
  static const String _baseIp = '192.168.0.165';
  static const String _basePath = 'perpustakaan';

  static String get apiBaseUrl => 'http://$_baseIp/$_basePath/api';
  static String get imageBaseUrl => 'http://$_baseIp/$_basePath/dist/pustaka/gambar';
  static String get imageProfileUrl => 'http://$_baseIp/$_basePath/dist/anggota/foto';
}
