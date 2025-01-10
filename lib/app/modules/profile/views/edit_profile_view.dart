import 'package:flutter/material.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final EditProfileController _controller = EditProfileController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    await _controller.getUserProfile();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _controller.saveProfile();

    setState(() {
      _isLoading = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profil berhasil diperbarui!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal memperbarui profil: $result'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _controller.nameController,
                      decoration: InputDecoration(labelText: 'Nama Lengkap'),
                    ),
                    TextField(
                      controller: _controller.emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      enabled: false, // Email tetap tidak dapat diubah
                    ),
                    TextField(
                      controller: _controller.phoneController,
                      decoration: InputDecoration(labelText: 'Nomor Telepon'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text('Simpan Perubahan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00a55a),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
