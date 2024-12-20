import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/keterlambatan_models.dart';
import '../models/aturan_pustaka_models.dart';
import '../services/keterlambatan_services.dart';
import '../services/aturan_pustaka_services.dart';
import 'package:intl/intl.dart';

class KeterlambatanPage extends StatefulWidget {
  const KeterlambatanPage({super.key});

  @override
  KeterlambatanPageState createState() => KeterlambatanPageState();
}

class KeterlambatanPageState extends State<KeterlambatanPage> {
  late Future<List<Keterlambatan>> _keterlambatan;
  late Future<AturanPustaka> _aturanPustaka;
  final KeterlambatanService _keterlambatanService = KeterlambatanService();
  final AturanPustakaService _aturanPustakaService = AturanPustakaService();

  @override
  void initState() {
    super.initState();
    _loadKeterlambatan();
    _aturanPustaka = _aturanPustakaService.fetchAturanPustaka();
  }

  Future<void> _loadKeterlambatan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? kodePengguna = prefs.getString('kode_pengguna');

    if (kodePengguna != null) {
      setState(() {
        _keterlambatan = _keterlambatanService.fetchKeterlambatan(kodePengguna);
      });
    } else {
      print('kode_pengguna tidak ditemukan di SharedPreferences.');
    }
  }

  Future<void> _refreshData() async {
    await _loadKeterlambatan();
    // You can also refresh other data if needed
  }

  String _formatCurrency(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(amount);
  }

  Widget _buildHeader(AturanPustaka aturan) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        'Perpustakaan menerapkan aturan waktu peminjaman pustaka selama ${aturan.waktuPeminjaman} hari dihitung sejak tanggal peminjaman. Apabila melebihi waktu tersebut maka akan dikenakan denda keterlambatan sebesar ${_formatCurrency(aturan.dendaKeterlambatan)}/Hari.',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keterlambatan', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Keterlambatan>>(
        future: _keterlambatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_off, size: 64, color: Colors.orange),
                    SizedBox(height: 16),
                    Text(
                      'Kamu belum memiliki data peminjaman yang aktif saat ini',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No late book loans available.'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: CustomScrollView(
                slivers: [
                  FutureBuilder<AturanPustaka>(
                    future: _aturanPustaka,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Error loading aturan pustaka.'),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final aturan = snapshot.data!;
                        return SliverToBoxAdapter(
                          child: _buildHeader(aturan),
                        );
                      } else {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Aturan pustaka tidak ditemukan.'),
                          ),
                        );
                      }
                    },
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final keterlambatan = snapshot.data![index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.orange,
                              child: Text(
                                keterlambatan.code,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              keterlambatan.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                                      const SizedBox(width: 4),
                                      Text('Tanggal Pinjam: ${keterlambatan.borrowDate}', style: const TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                                      const SizedBox(width: 4),
                                      Text('Harus Kembali: ${keterlambatan.dueDate}', style: const TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  _buildInfoBox(
                                    'Status',
                                    keterlambatan.status,
                                    keterlambatan.status == 'Sedang Dipinjam'
                                        ? Colors.green
                                        : keterlambatan.status == 'Telah Selesai'
                                            ? Colors.blue
                                            : Colors.red,
                                  ),
                                  _buildInfoBox(
                                    'Terlambat',
                                    keterlambatan.late,
                                    Colors.red,
                                  ),
                                  _buildInfoBox(
                                    'Perkiraan Denda',
                                    _formatCurrency(int.tryParse(keterlambatan.fineAmount) ?? 0),
                                    Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: snapshot.data!.length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Harap diperhatikan tanggal pengembalian agar tidak dikenakan denda.',
                        style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
