import 'package:app/app/modules/spp/views/inputspp_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../controllers/data_spp_controller.dart';

class ViewSppPage extends StatelessWidget {
  const ViewSppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataSppController controller = Get.put(DataSppController());
    final TextEditingController dateController = TextEditingController();
    final selectedFormat = 'yyyy-MM-dd'.obs; // Default format

    // Menambahkan FocusNode untuk mendeteksi fokus
    final FocusNode _dateFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lihat Data SPP',
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
            icon: const Icon(Icons.print),
            onPressed: () {
              // Implement print to PDF functionality
            },
          ),
        ],
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
            Row(
              children: [
                Obx(() {
                  return DropdownButton<String>(
                    value: selectedFormat.value,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedFormat.value = newValue;
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'yyyy-MM-dd',
                        child: Text('Tanggal'),
                      ),
                      DropdownMenuItem(
                        value: 'yyyy-MM',
                        child: Text('Bulan'),
                      ),
                      DropdownMenuItem(
                        value: 'yyyy',
                        child: Text('Tahun'),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 20),
                Obx(() {
                  return Text('Format yang dipilih: ${selectedFormat.value}');
                }),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: dateController,
                    focusNode: _dateFocusNode, // Menambahkan focusNode
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      suffixIcon: const Icon(Icons.calendar_today,color: Color(0xFF00a55a),),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate;

                      if (selectedFormat == 'yyyy-MM-dd') {
                        pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          controller.date(dateController.text);
                        }
                      } else if (selectedFormat == 'yyyy-MM') {
                        final now = DateTime.now();
                        final month = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light(),
                              child: child!,
                            );
                          },
                        );
                        if (month != null) {
                          dateController.text =
                              DateFormat('yyyy-MM').format(month);
                          controller.date(dateController.text);
                        }
                      } else if (selectedFormat == 'yyyy') {
                        final year = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (year != null) {
                          dateController.text = DateFormat('yyyy').format(year);
                          controller.date(dateController.text);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.filterData(selectedFormat.value);
              },
              child: const Text('Filter'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00a55a),
                  foregroundColor: Colors.white
                ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<DataSppController>(
                builder: (controller) {
                  if (controller.sppData.isEmpty) {
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
                        DataColumn(label: Text('Jumlah SPP',
                          style: TextStyle(
                            color: Color(0xFF00a55a),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(label: Text('Tanggal',
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
                      rows: controller.sppData.map((data) {
                        final nis = data['nis'] ?? '';
                        final name = data['name'] ?? '';
                        final kelas = data['kelas'] ?? '';
                        final sppAmount = data['sppAmount']?.toString() ?? '';
                        final timestamp = data['timestamp'];
                        final formattedDate = timestamp != null
                            ? DateFormat('dd-MM-yyyy')
                                .format((timestamp as Timestamp).toDate())
                            : 'Tanggal Tidak Tersedia';

                        return DataRow(cells: [
                          DataCell(Text(nis)),
                          DataCell(Text(name)),
                          DataCell(Text(kelas)),
                          DataCell(Text(sppAmount)),
                          DataCell(Text(formattedDate)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF00a55a)),
                                onPressed: () {
                                  print('ID Dokumen untuk update: ${data.id}');
                                  Get.to(() => inputsppView(
                                    id: data.id,
                                    nis: data['nis'],
                                    name: data['name'],
                                    kelas: data['kelas'],
                                    angkatan: int.tryParse(data['angkatan']?.toString() ?? ''),
                                    sppAmount: int.tryParse(data['sppAmount']?.toString() ?? ''),
                                    timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
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

