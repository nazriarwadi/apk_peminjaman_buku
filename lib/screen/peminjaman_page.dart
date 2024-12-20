import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/peminjaman_models.dart';
import '../services/peminjaman_services.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  BorrowPageState createState() => BorrowPageState();
}

class BorrowPageState extends State<BorrowPage> {
  late Future<List<BookLoan>> _bookLoans;
  final BookLoanService _service = BookLoanService();

  @override
  void initState() {
    super.initState();
    _loadBookLoans();
  }

  Future<void> _loadBookLoans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? kodePengguna = prefs.getString('kode_pengguna');

    if (kodePengguna != null) {
      setState(() {
        _bookLoans = _service.fetchBookLoans(kodePengguna);
      });
    } else {
      print('kode_pengguna tidak ditemukan di SharedPreferences.');
    }
  }

  Future<void> _refreshData() async {
    await _loadBookLoans();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Belum diambil':
        return Colors.grey;
      case 'Sedang Dipinjam':
        return Colors.blue;
      case 'Telah Selesai':
        return Colors.green;
      case 'Batal':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<BookLoan>>(
        future: _bookLoans,
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
                    Icon(Icons.book, size: 64, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'Saat ini kamu belum memiliki riwayat peminjaman. Mulailah meminjam buku dan kembali ke sini untuk melihat riwayatmu',
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
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Saat ini kamu belum memiliki riwayat peminjaman. Mulailah meminjam buku dan kembali ke sini untuk melihat riwayatmu.',
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
          } else {
            final bookLoans = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: bookLoans.length,
                itemBuilder: (context, index) {
                  final loan = bookLoans[index];
                  final statusColor = _getStatusColor(loan.status);
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        child: Text(
                          loan.code,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        loan.title,
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
                                Text('Mulai: ${loan.startTime}', style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                                const SizedBox(width: 4),
                                Text('Selesai: ${loan.endTime.isNotEmpty ? loan.endTime : '-'}', style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: Colors.grey[700]),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'Status: ${loan.status}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.print, color: Colors.grey.shade700),
                        onPressed: () {
                          _printLoanDetails(loan);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _printLoanDetails(BookLoan loan) {
    print('Printing loan details for ${loan.title} (${loan.code}):');
    print('Start Time: ${loan.startTime}');
    print('End Time: ${loan.endTime}');
    print('Status: ${loan.status}');
  }
}
