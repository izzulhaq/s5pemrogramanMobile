import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataStudentController extends GetxController {
  // Reactive variables to store filter values
  var nis = ''.obs;
  var name = ''.obs;
  var kelas = ''.obs;
  var angkatan = ''.obs;
  var birthdate = ''.obs;
  var birthplace = ''.obs;
  var phoneNumber = ''.obs;
  var address = ''.obs;

  // Reactive variable to store the filtered data
  var studentData = <DocumentSnapshot>[];

  // Instance of Firebase Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to apply filter
    Future<void> filterData(selectedFormat) async {
      Query query = firestore.collection('siswa');

      // Apply filters only if the values are not empty
      if (nis.isNotEmpty) {
        query = query.where('nis', isEqualTo: nis.value);
      }
      if (name.isNotEmpty) {
        query = query.where('name', isEqualTo: name.value);
      }
      if (kelas.isNotEmpty) {
        query = query.where('kelas', isEqualTo: kelas.value);
      }
      if (angkatan.isNotEmpty) {
        query = query.where('angkatan', isEqualTo: angkatan.value);
      }
      if (address.isNotEmpty) {
        query = query.where('address', isEqualTo: angkatan.value);
      }
      if (birthplace.isNotEmpty) {
        query = query.where('birthplace', isEqualTo: angkatan.value);
      }
      if (angkatan.isNotEmpty) {
        query = query.where('phoneNumber', isEqualTo: angkatan.value);
      }

      // Apply date filter (range query)
      if (birthdate.isNotEmpty) {
        try {
          DateTime parsedDate = DateTime.now();
          // Check the selected format
          if (selectedFormat == 'yyyy-MM-dd') {
            parsedDate = DateFormat('yyyy-MM-dd').parse(birthdate.value);
          } else if (selectedFormat == 'yyyy-MM') {
            // If selected format is yyyy-MM, set the start of the month (1st day)
            parsedDate = DateFormat('yyyy-MM').parse(birthdate.value + '-01');
          } else if (selectedFormat == 'yyyy') {
            // If selected format is yyyy, set the start of the year (1st January)
            parsedDate = DateFormat('yyyy').parse(birthdate.value + '-01-01');
          }

          // Set the start and end of the month if the selected format is 'yyyy-MM'
          if (selectedFormat == 'yyyy-MM') {
            // Get the first day of the selected month
            final startOfMonth = DateTime(parsedDate.year, parsedDate.month, 1);
            // Get the last day of the selected month
            final endOfMonth = DateTime(parsedDate.year, parsedDate.month + 1, 0, 23, 59, 59);

            // Convert these dates to Firestore Timestamps
            final Timestamp startTimestamp = Timestamp.fromDate(startOfMonth);
            final Timestamp endTimestamp = Timestamp.fromDate(endOfMonth);

            query = query.where('timestamp', isGreaterThanOrEqualTo: startTimestamp);
            query = query.where('timestamp', isLessThanOrEqualTo: endTimestamp);
          } else if (selectedFormat == 'yyyy') {
            // If selected format is 'yyyy', filter the entire year
            final startOfYear = DateTime(parsedDate.year, 1, 1);
            final endOfYear = DateTime(parsedDate.year, 12, 31, 23, 59, 59);

            // Convert these dates to Firestore Timestamps
            final Timestamp startTimestamp = Timestamp.fromDate(startOfYear);
            final Timestamp endTimestamp = Timestamp.fromDate(endOfYear);

            query = query.where('timestamp', isGreaterThanOrEqualTo: startTimestamp);
            query = query.where('timestamp', isLessThanOrEqualTo: endTimestamp);
          }

        } catch (e) {
          // If parsing fails, handle error or show an alert
          print("Invalid date format");
        }
      }

      // Get the data after applying filters
      final snapshot = await query.get();
      studentData = snapshot.docs;
      update(); // Update the UI
    }
}
