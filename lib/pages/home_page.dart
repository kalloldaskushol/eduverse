import 'package:flutter/material.dart';

import '../db/profile_db.dart';
import 'courses_page.dart';
import 'my_questions_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final Future<Map<String, dynamic>?> _profileFuture;

  final List<String> _titles = const [
    'Courses',
    'My Questions',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileDb().getCurrentProfile();
  }

  Widget _buildCurrentPage() {
    if (_selectedIndex == 0) {
      return FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          String fullName = 'Student';

          if (snapshot.hasData && snapshot.data != null) {
            final profile = snapshot.data!;
            fullName = profile['full_name'] as String;
          }

          return CoursesPage(fullName: fullName);
        },
      );
    }

    if (_selectedIndex == 1) {
      return const MyQuestionsPage();
    }

    return const ProfilePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined),
            label: 'Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
