import 'package:flutter/material.dart';

import 'package:eduverse/auth/auth_services.dart';
import 'package:eduverse/db/profile_db.dart';
import 'package:eduverse/widgets/empty_state_widget.dart';
import 'package:eduverse/widgets/info_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ProfileDb().getCurrentProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = snapshot.data;

        if (profile == null) {
          return const EmptyStateWidget(
            title: 'Profile not found',
            message: 'Complete registration first to see your profile.',
            icon: Icons.person_search_outlined,
          );
        }

        final fullName = profile['full_name'] as String;
        final universityName = profile['university_name'] as String;
        final email = profile['email'] as String;
        final userId = profile['id'].toString();
        final screenWidth = MediaQuery.of(context).size.width;
        final contentWidth = screenWidth > 800 ? 720.0 : screenWidth * 0.9;

        return Center(
          child: SizedBox(
            width: contentWidth,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.person, color: Colors.white, size: 45),
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    icon: Icons.badge_outlined,
                    label: 'Full Name',
                    value: fullName,
                  ),
                  InfoCard(
                    icon: Icons.school_outlined,
                    label: 'University Name',
                    value: universityName,
                  ),
                  InfoCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: email,
                  ),
                  InfoCard(
                    icon: Icons.fingerprint,
                    label: 'User ID',
                    value: userId,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      await AuthServices().signOut();
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
