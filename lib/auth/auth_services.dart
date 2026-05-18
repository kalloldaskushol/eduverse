import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return _supabase.auth.signInWithPassword( // Its a building method for signing in with email and password.
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Gets the currently authenticated user. return type is User? because it can be null if no user is logged in.
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  String? getCurrentUid() {
    return getCurrentUser()?.id;
  }

  String? getCurrentEmail() {
    return getCurrentUser()?.email;
  }
}
