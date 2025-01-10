import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InputScheduleView extends StatefulWidget {
  final String? id; // ID jadwal untuk edit, null jika baru
  const InputScheduleView({Key? key, this.id}) : super(key: key);

  @override
  _InputScheduleViewState createState() => _InputScheduleViewState();
}

class _InputScheduleViewState extends State<InputScheduleView> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _dayController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _roomController = TextEditingController();
  String _selectedClass = 'A1'; // Default kelas

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      // Jika editing, ambil data jadwal berdasarkan ID
      _loadScheduleData();
    }
  }

  void _loadScheduleData() async {
    var doc = await FirebaseFirestore.instance.collection('schedules').doc(widget.id).get();
    if (doc.exists) {
      var data = doc.data()!;
      _subjectController.text = data['subject'];
      _dayController.text = data['day'];
      _startTimeController.text = data['start_time'];
      _endTimeController.text = data['end_time'];
      _roomController.text = data['room'];
      _selectedClass = data['class'];
      setState(() {});
    }
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final scheduleData = {
        'subject': _subjectController.text,
        'day': _dayController.text,
        'start_time': _startTimeController.text,
        'end_time': _endTimeController.text,
        'room': _roomController.text,
        'class': _selectedClass,
      };

      if (widget.id == null) {
        // Jika ID null, berarti menambah data baru
        await FirebaseFirestore.instance.collection('schedules').add(scheduleData);
      } else {
        // Jika ada ID, berarti mengedit data
        await FirebaseFirestore.instance.collection('schedules').doc(widget.id).update(scheduleData);
      }

      Navigator.pop(context);
    } catch (e) {
      _showAlert('Error', e.toString());
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input Jadwal Pelajaran',
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Dropdown untuk memilih kelas
              DropdownButtonFormField<String>(
                value: _selectedClass,
                onChanged: (String? newClass) {
                  setState(() {
                    _selectedClass = newClass!;
                  });
                },
                items: <String>['A1', 'A2', 'A3', 'B1', 'B2', 'B3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Kelas'),
              ),
              // Field untuk Mata Pelajaran
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Mata Pelajaran'),
                validator: (value) => value!.isEmpty ? 'Mata pelajaran tidak boleh kosong' : null,
              ),
              // Field untuk Hari
              TextFormField(
                controller: _dayController,
                decoration: InputDecoration(labelText: 'Hari'),
                validator: (value) => value!.isEmpty ? 'Hari tidak boleh kosong' : null,
              ),
              // Field untuk Jam Mulai
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(labelText: 'Jam Mulai'),
                validator: (value) => value!.isEmpty ? 'Jam mulai tidak boleh kosong' : null,
              ),
              // Field untuk Jam Selesai
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(labelText: 'Jam Selesai'),
                validator: (value) => value!.isEmpty ? 'Jam selesai tidak boleh kosong' : null,
              ),
              // Field untuk Ruangan
              TextFormField(
                controller: _roomController,
                decoration: InputDecoration(labelText: 'Ruangan'),
                validator: (value) => value!.isEmpty ? 'Ruangan tidak boleh kosong' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSchedule,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00a55a),
                    foregroundColor: Colors.white,
                  ),
                child: Text(widget.id == null ? 'Simpan Jadwal' : 'Perbarui Jadwal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
