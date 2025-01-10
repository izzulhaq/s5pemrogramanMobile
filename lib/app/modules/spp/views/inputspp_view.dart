import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/app/modules/spp/controllers/inputspp_controller.dart';

class inputsppView extends StatefulWidget {
  final String? id;  // Ubah dari nis ke id
  final String? nis;
  final String? name;
  final String? kelas;
  final int? angkatan;
  final int? sppAmount;
  final DateTime? timestamp;

  const inputsppView({
    Key? key,
    this.id, // ID dokumen yang dikirimkan untuk edit
    this.nis,
    this.name,
    this.kelas,
    this.angkatan,
    this.sppAmount,
    this.timestamp,
  }) : super(key: key);

  @override
  _inputsppViewState createState() => _inputsppViewState();
}

class _inputsppViewState extends State<inputsppView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = InputsppController();

  final _nisController = TextEditingController();
  final _nameController = TextEditingController();
  final _kelasController = TextEditingController();
  final _angkatanController = TextEditingController();
  final _sppAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      // Jika ID ada, ambil data berdasarkan ID dokumen untuk edit
      _nisController.text = widget.nis ?? ''; 
      _nameController.text = widget.name ?? ''; 
      _kelasController.text = widget.kelas ?? ''; 
      _angkatanController.text = widget.angkatan?.toString() ?? ''; 
      _sppAmountController.text = widget.sppAmount?.toString() ?? ''; 
    }
  }

  Future<void> _searchNis() async {
    final nis = _nisController.text.trim();
    if (nis.isEmpty) {
      _showAlert('Error', 'NIS tidak boleh kosong.');
      return;
    }

    try {
      final data = await _controller.searchNis(nis);
      if (data != null) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _kelasController.text = data['kelas'] ?? '';
          _angkatanController.text = (data['angkatan'] ?? '').toString();
        });
      } else {
        _showAlert('Data Tidak Ditemukan', 'Siswa dengan NIS $nis tidak ditemukan.');
      }
    } catch (e) {
      _showAlert('Error', e.toString());
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final id = widget.id ?? ''; // ID dokumen untuk update atau insert
      final isUpdate = widget.id != null; // Menentukan apakah update atau insert

      if (isUpdate) {
        // Cek apakah data sudah ada di Firestore berdasarkan ID dokumen
        final existingDoc = await FirebaseFirestore.instance.collection('spp').doc(id).get();
        if (!existingDoc.exists) {
          _showAlert('Error', 'Data dengan ID $id tidak ditemukan untuk diperbarui.');
          return;
        }
      }

      await _controller.saveData(
        id: id,
        nis: _nisController.text,
        name: _nameController.text,
        kelas: _kelasController.text,
        angkatan: int.parse(_angkatanController.text),
        sppAmount: int.parse(_sppAmountController.text),
        timestamp: widget.timestamp,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input SPP',
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nisController,
                        decoration: const InputDecoration(
                          labelText: 'NIS',
                        ),
                        onFieldSubmitted: (_) => _searchNis(),
                        validator: (value) => value!.isEmpty ? 'NIS Tidak Boleh Kosong' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(onPressed: _searchNis, icon: const Icon(Icons.search, color: Color(0xFF00a55a),)),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _kelasController,
                  decoration: const InputDecoration(labelText: 'Kelas'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _angkatanController,
                  decoration: const InputDecoration(labelText: 'Angkatan'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _sppAmountController,
                  decoration: const InputDecoration(labelText: 'Jumlah SPP'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Jumlah SPP is required' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00a55a),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(widget.id == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
