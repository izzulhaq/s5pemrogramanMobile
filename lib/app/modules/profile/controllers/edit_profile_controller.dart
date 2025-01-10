import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? uid;

  // Mendapatkan data pengguna dari Firestore dan Firebase Auth
  Future<void> getUserProfile() async {
    User? user = _auth.currentUser;

    if (user != null) {
      uid = user.uid;

      // Ambil data email dari Firebase Auth
      emailController.text = user.email ?? '';

      // Ambil data lainnya dari Firestore berdasarkan UID
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        nameController.text = userDoc['name'] ?? '';
        phoneController.text = userDoc['phone'] ?? '';
      }
    }
  }

  // Menyimpan perubahan profil ke Firestore
  Future<String?> saveProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Update data profil di Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'name': nameController.text,
          'phone': phoneController.text,
        });
        return null; // Berhasil
      }
    } catch (e) {
      return e.toString(); // Gagal
    }
    return 'User tidak ditemukan.';
  }

  // Membersihkan controller
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }
}
