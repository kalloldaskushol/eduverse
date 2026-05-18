import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDb {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createProfile({
    required String id,
    required String fullName,
    required String universityName,
    required String email,
  }) async {
    await _supabase.from('profiles').insert({
      'id': id,
      'full_name': fullName,
      'university_name': universityName,
      'email': email,
    });
  }

  Future<Map<String, dynamic>?> getCurrentProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return null;
    }

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle(); // Use maybeSingle to avoid exceptions if no record is found

    if (response == null) {
      return null;
    }

    return Map<String, dynamic>.from(response);
  }
}
