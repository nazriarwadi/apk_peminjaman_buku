import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/denda_models.dart';
import '../services/denda_services.dart';

class FinePage extends StatefulWidget {
  const FinePage({super.key});

  @override
  FinePageState createState() => FinePageState();
}

class FinePageState extends State<FinePage> {
  late Future<List<FineDetail>> _fines;
  final FineService _service = FineService();

  @override
  void initState() {
    super.initState();
    _loadFines();
  }

  Future<void> _loadFines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? kodePengguna = prefs.getString('kode_pengguna');

    if (kodePengguna != null) {
      setState(() {
        _fines = _service.fetchFines(kodePengguna);
      });
    } else {
      print('kode_pengguna tidak ditemukan di SharedPreferences.');
    }
  }

  Future<void> _refreshData() async {
    await _loadFines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Denda', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<FineDetail>>(
        future: _fines,
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
                    Icon(Icons.money_off, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Kamu belum mempunyai denda untuk buku yang kamu pinjam',
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
            return const Center(child: Text('No fines available.'));
          } else {
            final fines = snapshot.data!;
            double totalFine = fines.fold(
              0.0,
              (sum, item) => sum + double.parse(
                item.amount.replaceAll('.', '').replaceAll(',', '.'),
              ),
            );
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: fines.length,
                      itemBuilder: (context, index) {
                        final fine = fines[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red,
                              child: Text(
                                fine.code,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              fine.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                                    const SizedBox(width: 4),
                                    Text('Tanggal: ${fine.date}', style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.info_outline, size: 16, color: Colors.black54),
                                    const SizedBox(width: 4),
                                    Text('Jenis Denda: ${fine.type}', style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, size: 16, color: Colors.red),
                                    const SizedBox(width: 4),
                                    Text('Besaran: Rp. ${fine.amount}', style: const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Total Denda: Rp. ${totalFine.toStringAsFixed(2).replaceAll('.', ',').replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
