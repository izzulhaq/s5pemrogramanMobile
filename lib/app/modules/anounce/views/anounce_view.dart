import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'inputanounce_view.dart';

class AnounceView extends StatefulWidget {
  const AnounceView({Key? key}) : super(key: key);

  @override
  _DataView createState() => _DataView();
}

class _DataView extends State<AnounceView> {
  final CollectionReference _weatherCollection =
      FirebaseFirestore.instance.collection("anounce");

  Future<void> _deleteWeather(String id) async {
    await _weatherCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengumuman',
          style: TextStyle(
            color: Color(0xFF00a55a),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        iconTheme: IconThemeData(
          size: 30,
          color: Color(0xFF00a55a),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            color: Colors.white,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _weatherCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final nis = data.id;
              final Title = data['title'] ?? 'Default Title';
              final description = data['description'] ?? 'No description available';
              final tgl = data['tgl']; // Ambil data tgl yang berupa Timestamp
              final formattedDate = tgl != null
                  ? (tgl is Timestamp
                      ? DateFormat('dd-MM-yyyy').format(tgl.toDate())  // Konversi Timestamp ke DateTime
                      : DateFormat('dd-MM-yyyy').format(DateTime.parse(tgl.toString())))
                  : 'Tanggal Tidak Tersedia';


              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(Title,
                    style: TextStyle(
                      color: Color(0xFF00a55a)
                    ),
                  ),
                  subtitle: Text(
                    '$description\n$formattedDate',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF00a55a)),
                        onPressed: () {
                          print('ID Dokumen untuk update: ${data.id}');
                          Get.to(() => InputanounceView(
                            id: data.id,
                            title: data['title'],
                            description: data['description'],
                            tgl: (data['tgl'] is Timestamp)
                                ? (data['tgl'] as Timestamp).toDate()
                                : DateTime.tryParse(data['tgl']?.toString() ?? ''),
                          ));
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Konfirmasi Hapus',
                                style: TextStyle(
                                  color: Color(0xFF00a55a),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Batal',
                                    style: TextStyle(
                                      color: Color(0xFF00a55a),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _deleteWeather(nis); // Menghapus data dengan id dari nis
                                    Navigator.pop(context); // Menutup dialog
                                    setState(() {}); // Memperbarui tampilan setelah penghapusan
                                  },
                                  child: const Text(
                                    'Hapus',
                                    style: TextStyle(
                                      color: Color(0xFF00a55a),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InputanounceView(),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xFF00a55a),
        foregroundColor: Colors.white,
      ),
    );
  }
}
