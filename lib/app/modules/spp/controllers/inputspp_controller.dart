import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InputsppController {
  final _sppCollection = FirebaseFirestore.instance.collection('spp');
  final _siswaCollection = FirebaseFirestore.instance.collection('siswa');

  // Fungsi untuk mencari data siswa berdasarkan NIS
  Future<Map<String, dynamic>?> searchNis(String nis) async {
    try {
      final doc = await _siswaCollection.doc(nis).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null; // Jika tidak ditemukan, kembalikan null
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk menyimpan atau memperbarui data
  Future<void> saveData({
    required String id,  // Ganti nis dengan id
    required String nis,
    required String name,
    required String kelas,
    required int angkatan,
    required int sppAmount,
    required DateTime? timestamp,
    bool isUpdate = false,
  }) async {
    final data = {
      'nis': nis,  // Menyimpan nis tetap di dalam data, meskipun update berdasarkan id
      'name': name,
      'kelas': kelas,
      'angkatan': angkatan,
      'sppAmount': sppAmount,
      'timestamp': timestamp ?? Timestamp.now(), // Timestamp saat ini jika tidak diberikan
    };

    try {
      if (isUpdate) {
        // Jika isUpdate = true, lakukan update berdasarkan ID dokumen
        await _sppCollection.doc(id).update(data);
      } else {
        // Jika isUpdate = false, simpan data baru dengan ID dokumen otomatis
        await _sppCollection.add(data); // Gunakan `add()` untuk dokumen baru dengan ID otomatis
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menyimpan data: $e');
    }
  }
}
