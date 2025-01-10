import 'package:app/app/modules/spp/views/inputspp_view.dart';
import 'package:app/app/modules/students/views/student_form_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../controllers/data_Student_controller.dart';

class ViewStudentPage extends StatelessWidget {
  const ViewStudentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataStudentController controller = Get.put(DataStudentController());
    final TextEditingController dateController = TextEditingController();
    final selectedFormat = 'yyyy-MM-dd'.obs; // Default format

    // Menambahkan FocusNode untuk mendeteksi fokus
    final FocusNode _dateFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lihat Data Siswa',
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
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Cari NIS',
                    ),
                    onChanged: (value) {
                      controller.nis(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Cari Nama',
                    ),
                    onChanged: (value) {
                      controller.name(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Kelas',
                    ),
                    onChanged: (value) {
                      controller.kelas(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Angkatan',
                    ),
                    onChanged: (value) {
                      controller.angkatan(value);
                    },
                  ),
                ),
              ],
            ),  
            const SizedBox(height: 16),
            
            const SizedBox(height: 16),
            
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.filterData(selectedFormat.value);
              },
              child: const Text('Filter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF02a661), // Warna latar belakang (background)
                foregroundColor: Colors.white,
                fixedSize: Size(380, 50)    // Warna teks (label)
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<DataStudentController>(
                builder: (controller) {
                  if (controller.studentData.isEmpty) {
                    return const Center(child: Text('No data available.'));
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('NIS',
                          style: TextStyle(
                            color: Color(0xFF00a55a),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(label: Text('Nama',
                        style: TextStyle(
                          color: Color(0xFF00a55a),
                          fontWeight: FontWeight.bold,
                        ),
                        )),
                        DataColumn(label: Text('Kelas',
                        style: TextStyle(
                          color: Color(0xFF00a55a),
                          fontWeight: FontWeight.bold,
                        ),
                        )),
                        DataColumn(label: Text('Angkatan',
                          style: TextStyle(
                            color: Color(0xFF00a55a),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(label: Text('Alamat',
                          style: TextStyle(
                            color: Color(0xFF00a55a),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(label: Text('No.Telp',
                          style: TextStyle(
                            color: Color(0xFF00a55a),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(label: Text('Tempat Lahir',
                          style: TextStyle(
                            color: Color(0xFF00a55a),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(label: Text('Tgl Lahir',
                          style: TextStyle(
                            color: Color(0xFF00a55a),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(label: Text('Aksi',
                          style: TextStyle(
                            color: Color(0xFF00a55a),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                      rows: controller.studentData.map((data) {
                        final nis = data['nis']?.toString() ?? '';
                        final name = data['name'] ?? '';
                        final kelas = data['kelas'] ?? '';
                        final angkatan = data['angkatan']?.toString() ?? '';
                        final address = data['address'] ?? '';
                        final phoneNumber = data['phoneNumber']?.toString() ?? '';
                        final birthplace = data['birthplace'] ?? '';
                        final birthdate = data['birthdate'];
                        final formattedDate = birthdate != null
                          ? (birthdate is Timestamp
                              ? DateFormat('dd-MM-yyyy').format(birthdate.toDate())
                              : DateFormat('dd-MM-yyyy').format(DateTime.parse(birthdate.toString())))
                          : 'Tanggal Tidak Tersedia';



                        return DataRow(cells: [
                          DataCell(Text(nis)),
                          DataCell(Text(name)),
                          DataCell(Text(kelas)),
                          DataCell(Text(angkatan)),
                          DataCell(Text(address)),
                          DataCell(Text(phoneNumber)),
                          DataCell(Text(birthplace)),
                          DataCell(Text(formattedDate)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF00a55a)),
                                onPressed: () {
                                  print('ID Dokumen untuk update: ${data.id}');
                                  Get.to(() => StudentFormView(
                                    id: data.id,
                                    nis: data['nis'],
                                    name: data['name'],
                                    kelas: data['kelas'],
                                    angkatan: int.tryParse(data['angkatan']?.toString() ?? ''),
                                    phoneNumber: data['phoneNumber'],
                                    birthplace: data['birthplace'],
                                    birthdate: (data['birthdate'] is Timestamp)
                                        ? (data['birthdate'] as Timestamp).toDate()
                                        : DateTime.tryParse(data['birthdate']?.toString() ?? ''),
                                  ));

                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi Hapus',
                                        style: TextStyle(
                                          color: Color(0xFF00a55a),
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Batal',
                                            style: TextStyle(
                                              color: Color(0xFF00a55a),
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('spp')
                                                .doc(data.id)
                                                .delete();
                                            Navigator.pop(context);
                                            controller.filterData(selectedFormat.value);
                                          },
                                          child: const Text('Hapus',
                                            style: TextStyle(
                                              color: Color(0xFF00a55a),
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.filterData(selectedFormat.value);
        },
        child: const Icon(Icons.refresh),
        backgroundColor: const Color(0xFF00a55a),
        foregroundColor: Colors.white
      ),
    );
  }
}

