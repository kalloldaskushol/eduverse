import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_services.dart';

class QuestionsDb {
  final questionsTable = Supabase.instance.client.from('questions');

  Future<List<Map<String, dynamic>>> getQuestions(String userId) async {
    final response = await questionsTable
        .select()
        .eq('user_id', userId)
        .order('id', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertQuestion({
    required String title,
    required String subject,
    required String description,
  }) async {
    final userId = AuthServices().getCurrentUid();
    await questionsTable.insert({
      'user_id': userId,
      'title': title,
      'subject': subject,
      'description': description,
    });
  }

  Future<void> updateQuestion({
    required dynamic id,
    required String title,
    required String subject,
    required String description,
  }) async {
    await questionsTable.update({
      'title': title,
      'subject': subject,
      'description': description,
    }).eq('id', id);
  }

  Future<void> deleteQuestion(dynamic id) async {
    await questionsTable.delete().eq('id', id);
  }
}
