import 'package:flutter/material.dart';
import 'package:app/app/modules/anounce/controllers/anounce_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class InputanounceView extends StatefulWidget {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? tgl;

  const InputanounceView({
    Key? key,
    this.id,
    this.title,
    this.description,
    this.tgl,
  }) : super(key: key);

  @override
  _InputanounceViewState createState() => _InputanounceViewState();
}

class _InputanounceViewState extends State<InputanounceView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = AnounceController();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tglController = TextEditingController();
  DateTime? _tgl;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _titleController.text = widget.title ?? '';
      _descriptionController.text = widget.description ?? '';
      _tgl = widget.tgl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveAnounce() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final id = widget.id ?? '';
      final isUpdate = widget.id != null;

      await _controller.saveAnounce(
        id: id,
        title: _titleController.text,
        description: _descriptionController.text,
        tgl: _tgl ?? DateTime.now(),
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
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Color(0xFF00a55a), // Warna ikon tombol kembali
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.id == null ? 'Input Data Siswa' : 'Edit Data Siswa',
          style: TextStyle(
            color: Color(0xFF00a55a),
            fontWeight: FontWeight.bold
          ),
        ),
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
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Title Tidak Boleh Kosong' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  validator: (value) =>
                      value!.isEmpty ? 'Deskripsi Tidak Boleh Kosong' : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _tgl == null
                          ? 'Tanggal Lahir: Belum Dipilih'
                          : 'Tanggal Lahir: ${DateFormat('dd-MM-yyyy').format(_tgl!)}',
                    ),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _tgl ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _tgl = pickedDate;
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
                  onPressed: _saveAnounce,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF02a661),
                    foregroundColor: Colors.white,
                    fixedSize: Size(380, 50) 
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
