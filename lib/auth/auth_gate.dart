import 'package:eduverse/pages/home_page.dart';
import 'package:eduverse/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        //! Check the current session 
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) { // If session exists, user is logged in.
          return const HomePage();
        }
        // If session is null, user is not logged in.
        return const LoginPage();
      },
    );
  }
}
