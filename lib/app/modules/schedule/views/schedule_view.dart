import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  String _selectedClass = 'A1'; // Default kelas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lihat Jadwal Pelajaran',
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
      body: Column(
        children: [
          // Row untuk menampilkan teks dan dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Pilih Kelas: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                // Dropdown untuk memilih kelas
                DropdownButton<String>(
                  value: _selectedClass,
                  icon: Icon(Icons.arrow_drop_down),
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedClass = newValue!;
                    });
                  },
                  items: <String>['A1', 'A2', 'A3', 'B1', 'B2', 'B3']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // StreamBuilder untuk menampilkan jadwal berdasarkan kelas
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedules')
                  .where('class', isEqualTo: _selectedClass) // Filter jadwal berdasarkan kelas
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Tidak ada data jadwal.'));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    final subject = data['subject'];
                    final day = data['day'];
                    final startTime = data['start_time'];
                    final endTime = data['end_time'];
                    final room = data['room'];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(subject),
                        subtitle: Text('$day, $startTime - $endTime\nRuangan: $room'),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
