import 'package:flutter/material.dart';
import 'package:app/app/modules/students/controllers/student_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class StudentFormView extends StatefulWidget {
  final String? id;
  final String? nis;
  final String? name;
  final String? kelas;
  final int? angkatan;
  final String? address;
  final String? phoneNumber;
  final String? birthplace;
  final DateTime? birthdate;

  const StudentFormView({
    Key? key,
    this.id,
    this.nis,
    this.name,
    this.kelas,
    this.angkatan,
    this.address,
    this.phoneNumber,
    this.birthplace,
    this.birthdate,
  }) : super(key: key);

  @override
  _StudentFormViewState createState() => _StudentFormViewState();
}

class _StudentFormViewState extends State<StudentFormView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = StudentController();

  final _nisController = TextEditingController();
  final _nameController = TextEditingController();
  final _kelasController = TextEditingController();
  final _angkatanController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _birthplaceController = TextEditingController();
  DateTime? _birthdate;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _nisController.text = widget.nis ?? '';
      _nameController.text = widget.name ?? '';
      _kelasController.text = widget.kelas ?? '';
      _angkatanController.text = widget.angkatan?.toString() ?? '';
      _addressController.text = widget.address ?? '';
      _phoneNumberController.text = widget.phoneNumber ?? '';
      _birthplaceController.text = widget.birthplace ?? '';
      _birthdate = widget.birthdate;
    }
  }

  @override
  void dispose() {
    _nisController.dispose();
    _nameController.dispose();
    _kelasController.dispose();
    _angkatanController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _birthplaceController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final id = widget.id ?? '';
      final isUpdate = widget.id != null;

      await _controller.saveStudent(
        id: id,
        nis: _nisController.text,
        name: _nameController.text,
        kelas: _kelasController.text,
        angkatan: int.parse(_angkatanController.text),
        address: _addressController.text,
        phoneNumber: _phoneNumberController.text,
        birthplace: _birthplaceController.text,
        birthdate: _birthdate ?? DateTime.now(),
        isUpdate: isUpdate,
      );

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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String _selectedClass = 'A1';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Input Data Siswa' : 'Edit Data Siswa',
          style: TextStyle(
            color: Color(0xFF00a55a),
            fontWeight: FontWeight.bold
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nisController,
                  decoration: const InputDecoration(labelText: 'NIS'),
                  validator: (value) =>
                      value!.isEmpty ? 'NIS Tidak Boleh Kosong' : null,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama Tidak Boleh Kosong' : null,
                ),
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
                TextFormField(
                  controller: _angkatanController,
                  decoration: const InputDecoration(labelText: 'Angkatan'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'No. Telepon'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _birthplaceController,
                  decoration: const InputDecoration(labelText: 'Tempat Lahir'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _birthdate == null
                          ? 'Tanggal Lahir: Belum Dipilih'
                          : 'Tanggal Lahir: ${DateFormat('dd-MM-yyyy').format(_birthdate!)}',
                    ),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _birthdate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _birthdate = pickedDate;
                          });
                        }
                      },
                      child: const Text('Pilih Tanggal',
                        style: TextStyle(
                          color: Color(0xFF00a55a)
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF02a661), // Warna latar belakang (background)
                    foregroundColor: Colors.white,
                    fixedSize: Size(380, 50)    // Warna teks (label)
                  ),
                  child: Text(widget.id == null ? 'Simpan' : 'Perbarui'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
