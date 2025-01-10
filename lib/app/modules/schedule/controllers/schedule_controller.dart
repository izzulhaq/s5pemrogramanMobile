import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  var selectedClass = 'RA A1'.obs;
  var schedules = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSchedules();  // Load jadwal saat controller diinisialisasi
  }

  // Fungsi untuk mengambil jadwal berdasarkan kelas yang dipilih
  void _loadSchedules() {
    FirebaseFirestore.instance
        .collection('schedules')
        .where('class', isEqualTo: selectedClass.value)
        .snapshots()
        .listen((querySnapshot) {
      schedules.value = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'subject': doc['subject'],
          'day': doc['day'],
          'start_time': doc['start_time'],
          'end_time': doc['end_time'],
          'room': doc['room'],
        };
      }).toList();
    });
  }

  // Fungsi untuk mengambil jadwal berdasarkan id
  Map<String, dynamic> getScheduleById(String id) {
    try {
      return schedules.firstWhere((schedule) => schedule['id'] == id);
    } catch (e) {
      throw Exception('Jadwal tidak ditemukan!');
    }
  }

  // Fungsi untuk menambahkan atau memperbarui jadwal
  Future<void> saveSchedule(Map<String, dynamic> scheduleData, [String? id]) async {
    try {
      if (id == null) {
        // Menambah jadwal baru
        await FirebaseFirestore.instance.collection('schedules').add(scheduleData);
      } else {
        // Memperbarui jadwal yang sudah ada
        await FirebaseFirestore.instance.collection('schedules').doc(id).update(scheduleData);
      }
    } catch (e) {
      throw Exception('Error saving schedule: $e');
    }
  }

  // Fungsi untuk menghapus jadwal
  Future<void> deleteSchedule(String id) async {
    try {
      await FirebaseFirestore.instance.collection('schedules').doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting schedule: $e');
    }
  }

  // Fungsi untuk mengubah kelas yang dipilih
  void changeClass(String newClass) {
    selectedClass.value = newClass;
    _loadSchedules();  // Reload jadwal berdasarkan kelas yang baru
  }
}
