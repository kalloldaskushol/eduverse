import 'package:flutter/material.dart';

import 'package:eduverse/models/course_model.dart';
import 'package:eduverse/pages/course_details_page.dart';

class CoursesPage extends StatelessWidget {
  final String fullName;

  const CoursesPage({super.key, required this.fullName});

  static const List<CourseModel> _courses = [
    CourseModel(
      title: 'Flutter Basics',
      instructor: 'Md. Mahdi Hossain Hira',
      priceType: 'Free',
      description:
          'Learn widgets, layouts, navigation, and build your first mobile app.',
    ),
    CourseModel(
      title: 'Dart For Beginners',
      instructor: 'Kallol Das Kushol',
      priceType: 'Free',
      description:
          'Understand variables, functions, loops, and object-oriented basics.',
    ),
    CourseModel(
      title: 'Database Fundamentals',
      instructor: 'MHH',
      priceType: 'Paid',
      description:
          'A simple introduction to storing, reading, and organizing application data.',
    ),
    CourseModel(
      title: 'UI Design For Students',
      instructor: 'AGC',
      priceType: 'Paid',
      description:
          'Practice clean app layouts with cards, lists, spacing, and colors.',
    ),
    CourseModel(
      title: 'Object Oriented Programming',
      instructor: 'SAZ',
      priceType: 'Free',
      description:
          'Build a clear understanding of classes, objects, inheritance, and methods.',
    ),
    CourseModel(
      title: 'Software Engineering Basics',
      instructor: 'UAC',
      priceType: 'Paid',
      description:
          'Learn requirement analysis, project planning, and simple software design ideas.',
    ),
    CourseModel(
      title: 'Mobile App Project Practice',
      instructor: 'MHH',
      priceType: 'Free',
      description:
          'Apply beginner-friendly project ideas using Flutter, forms, and navigation.',
    ),
  ];

  Color _chipBackgroundColor(String priceType) {
    if (priceType == 'Free') {
      return Colors.green;
    }

    return Colors.orange;
  }

  Color _chipTextColor(String priceType) {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (_courses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_outlined, size: 60, color: Colors.indigo),
              SizedBox(height: 16),
              Text(
                'No courses available',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Sample courses will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to EduVerse',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Hello, $fullName',
                style: const TextStyle(fontSize: 15, color: Colors.white70),
              ),
            ],
          ),
        ),
        ..._courses.map((course) {
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsPage(course: course),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Chip(
                          backgroundColor: _chipBackgroundColor(
                            course.priceType,
                          ),
                          side: BorderSide.none,
                          label: Text(
                            course.priceType,
                            style: TextStyle(
                              color: _chipTextColor(course.priceType),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Instructor: ${course.instructor}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(course.description),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'View Course',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
