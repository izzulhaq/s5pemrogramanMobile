import 'package:app/app/modules/schedule/views/input_schedule_view.dart';
import 'package:app/app/modules/schedule/views/schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ScheduleMenu extends StatelessWidget {
  const ScheduleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Jadwal Pelajaan',
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
                leading: const Icon(FontAwesomeIcons.clock, color: Color(0xFF00a55a),),
                title: const Text('Input Jadwal',
                  style: TextStyle(
                    color: Color(0xFF00a55a),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Tambah Jadwal Pelajaran baru'),
                onTap: () {
                  Get.to(InputScheduleView());
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.timeline,color: Color(0xFF00a55a),),
                title: const Text('Lihat Jadwal Pelajaran',
                  style: TextStyle(
                    color: Color(0xFF00a55a),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Tampilkan dan filter Jadwal Pelajaran.'),
                onTap: () {
                  Get.to(ScheduleView());
                  Navigator.pushNamed(context, '/viewSchedule');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
