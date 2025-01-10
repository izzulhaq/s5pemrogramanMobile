import 'package:cloud_firestore/cloud_firestore.dart';

class StudentController {
  final _studentCollection = FirebaseFirestore.instance.collection('siswa');

  // Fungsi untuk mencari data siswa berdasarkan NIS
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
  Future<void> saveStudent({
    required String id, // ID dokumen
    required String nis,
    required String name,
    required String kelas,
    required int angkatan,
    required String address,
    required String phoneNumber,
    required String birthplace,
    required DateTime birthdate,
    bool isUpdate = false,
  }) async {
    final data = {
      'nis': nis,
      'name': name,
      'kelas': kelas,
      'angkatan': angkatan,
      'address': address,
      'phoneNumber': phoneNumber,
      'birthplace': birthplace,
      'birthdate': Timestamp.fromDate(birthdate), // Konversi ke Timestamp Firestore
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
