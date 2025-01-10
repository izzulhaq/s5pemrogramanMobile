import 'package:app/app/modules/spp/views/inputspp_view.dart';
import 'package:app/app/modules/spp/views/view_spp_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SppMenuView extends StatelessWidget {
  const SppMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu SPP',
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
                title: const Text('Input Data SPP',
                  style: TextStyle(
                    color: Color(0xFF00a55a),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Tambah data pembayaran SPP baru'),
                onTap: () {
                  Get.to(inputsppView());
                  Navigator.pushNamed(context, '/inputSpp');
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.tableCells,color: Color(0xFF00a55a),),
                title: const Text('Lihat Data SPP',
                  style: TextStyle(
                    color: Color(0xFF00a55a),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Tampilkan dan filter data pembayaran SPP.'),
                onTap: () {
                  Get.to(ViewSppPage());
                  Navigator.pushNamed(context, '/viewSpp');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
