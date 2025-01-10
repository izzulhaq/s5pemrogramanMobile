import 'package:cloud_firestore/cloud_firestore.dart';

class AnounceController {
  final _studentCollection = FirebaseFirestore.instance.collection('anounce');

  
  Future<Map<String, dynamic>?> searchStudentByNis(String nis) async {
    try {
      final doc = await _studentCollection.doc(nis).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null; // Jika tidak ditemukan, kembalikan null
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk menyimpan atau memperbarui data siswa
  Future<void> saveAnounce({
    required String id, // ID dokumen
    required String title,
    required String description,
    required DateTime tgl,
    bool isUpdate = false,
  }) async {
    final data = {
      'title': title,
      'description': description,
      'tgl': Timestamp.fromDate(tgl), // Konversi ke Timestamp Firestore

    };

    try {
      if (isUpdate) {
        await _studentCollection.doc(id).update(data);
      } else {
        await _studentCollection.add(data);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menyimpan data: $e');
    }
  }
}
