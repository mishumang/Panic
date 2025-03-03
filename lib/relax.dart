import 'package:flutter/material.dart';
import 'package:meditation_app/Instruction/instruction_abdo.dart';
import 'package:meditation_app/Instruction/instruction_complete.dart';
import 'package:meditation_app/Instruction/instruction_chest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditation_app/progress/graph.dart';
import 'profile/profile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/courses_page.dart';
import 'package:meditation_app/panic_breathing_page.dart'; // Import PanicBreathingPage

class RelaxScreen extends StatefulWidget {
  const RelaxScreen({Key? key}) : super(key: key);

  @override
  State<RelaxScreen> createState() => RelaxScreenState();
}

class RelaxScreenState extends State<RelaxScreen> {
  int _currentIndex = 0;
  String _userName = 'User';
  File? _profileImage;
  final ScrollController _scrollController = ScrollController();
  double _opacity = 1.0;

  final List<Widget> _screens = [
    CoursesPage(),
    ProgressScreen(),
    MeditationProfile(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = 'User';
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _handleScroll() {
    double newOpacity = 1.0 - (_scrollController.offset / 200).clamp(0.0, 1.0);
    setState(() {
      _opacity = newOpacity;
    });
  }

  // Navigate to Panic Breathing Page
  void _handlePanicButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PanicBreathingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_currentIndex == 0)
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          child: _profileImage == null
                              ? const Icon(Icons.add_a_photo, size: 30, color: Colors.blueGrey)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Hello, $_userName!',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 30),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Meditation'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      // Panic Button - Navigates to PanicBreathingPage
      floatingActionButton: FloatingActionButton(
        onPressed: _handlePanicButton,
        backgroundColor: Colors.red,
        child: const Icon(Icons.warning, color: Colors.white),
      ),
    );
  }
}
