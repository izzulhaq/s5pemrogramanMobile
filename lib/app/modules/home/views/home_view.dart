import 'package:app/app/modules/anounce/views/anounce_view.dart';
import 'package:app/app/modules/autentifikasi/views/login_view.dart';
import 'package:app/app/modules/profile/views/edit_profile_view.dart';
import 'package:app/app/modules/schedule/views/schedule_menu.dart';
import 'package:app/app/modules/students/views/student_menu_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app/app/modules/spp/views/spp_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0; // Untuk melacak slide aktif
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  User? _user;
  Map<String, dynamic>? _userData;


  @override
  void initState() {
    super.initState();
    // Memperoleh user yang sedang login
    _user = _auth.currentUser;
    if (_user != null) {
      _getUserData();
    }
  }

  // Fungsi untuk mengubah indeks slide saat halaman berganti
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Al Jauhar App',
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 235,
              color: Color(0xFF00a55a),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: _userData != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height:50),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              FontAwesomeIcons.userAstronaut,
                              size: 40,
                              color: const Color(0xFF00a55a),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _userData!['name'] ?? 'Name not available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _userData!['email'] ?? 'Email not available',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _userData!['phone'] ?? 'Phone not available',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: const Color(0xFF00a55a),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Aplikasi Manajemen Sekolah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Guest',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profil'),
              onTap: () {
                Get.to(EditProfileView());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Keluar'),
              onTap: () async {
                try {
                  // Logout dari Firebase
                  await FirebaseAuth.instance.signOut();

                  // Navigasi ke halaman login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                } catch (e) {
                  // Tampilkan pesan error jika logout gagal
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout gagal: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Bagian Slider Gambar
          Container(
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildImageSlider('assets/images/banner3.jpg', 'Al Jauhar\nraoudhotul Athfal Al Jauhar Karangploso'),
                  _buildImageSlider('assets/images/banner2.jpeg', 'Al Jauhar\nraoudhotul Athfal Al Jauhar Karangploso'),
                  _buildImageSlider('assets/images/banner1.jpeg', 'Al Jauhar\nraoudhotul Athfal Al Jauhar Karangploso'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Indikator Titik
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.green
                        : const Color.fromARGB(179, 177, 177, 177),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
          // GridView di bawah slider
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    icon: Icons.payment,
                    title: 'Pembayaran SPP',
                    onTap: () {
                      Get.to(SppMenuView());
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.schedule,
                    title: 'Jadwal Pelajaran',
                    onTap: () {
                      Get.to(ScheduleMenu());
                    },
                  ),
                  _buildFeatureCard(
                    icon: FontAwesomeIcons.userGraduate,
                    title: 'Data Siswa',
                    onTap: () {
                      Get.to(StudentMenuView());
                    },
                  ),
                  _buildFeatureCard(
                    icon: FontAwesomeIcons.solidBell,
                    title: 'Pengumuman',
                    onTap: () {
                      Get.to(AnounceView());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(String imagePath, String caption) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: 'Al Jauhar\n',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'raoudhotul Athfal Al Jauhar Karangploso',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Color(0xFF00a55a),
            ),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

