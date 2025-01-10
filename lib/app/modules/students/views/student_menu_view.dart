import 'package:app/app/modules/students/views/student_form_view.dart';
import 'package:app/app/modules/students/views/view_student_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class StudentMenuView extends StatelessWidget {
  const StudentMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Siswa',
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
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.add, color: Color(0xFF00a55a),),
                title: const Text('Input Data Siswa',
                  style: TextStyle(
                    color: Color(0xFF00a55a),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Tambah data Siswa baru'),
                onTap: () {
                  Get.to(StudentFormView());
                  Navigator.pushNamed(context, '/inputStudent');
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.bookOpen,color: Color(0xFF00a55a),),
                title: const Text('Lihat Data Siswa',
                  style: TextStyle(
                    color: Color(0xFF00a55a),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Tampilkan dan filter data Siswa.'),
                onTap: () {
                  Get.to(ViewStudentPage());
                  Navigator.pushNamed(context, '/viewStudent');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
