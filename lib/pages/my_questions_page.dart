import 'package:flutter/material.dart';

import 'package:eduverse/auth/auth_services.dart';
import 'package:eduverse/db/questions_db.dart';
import 'package:eduverse/widgets/custom_text_field.dart';

class MyQuestionsPage extends StatefulWidget {
  const MyQuestionsPage({super.key});

  @override
  State<MyQuestionsPage> createState() => _MyQuestionsPageState();
}

class _MyQuestionsPageState extends State<MyQuestionsPage> {
  final QuestionsDb _questionsDb = QuestionsDb();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final String? _userId = AuthServices().getCurrentUid();

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _openQuestionDialog({Map<String, dynamic>? question}) async {
    final isEditing = question != null;

    if (question != null) {
      _titleController.text = question['title'] as String;
      _subjectController.text = question['subject'] as String;
      _descriptionController.text = question['description'] as String;
    } else {
      _titleController.clear();
      _subjectController.clear();
      _descriptionController.clear();
    }

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Question' : 'Add New Question'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: _titleController,
                  labelText: 'Question Title',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _subjectController,
                  labelText: 'Subject',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final subject = _subjectController.text.trim();
                final description = _descriptionController.text.trim();

                if (title.isEmpty || subject.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields.')),
                  );
                  return;
                }

                try {
                  if (isEditing) {
                    await _questionsDb.updateQuestion(
                      id: question['id'],
                      title: title,
                      subject: subject,
                      description: description,
                    );
                  } else {
                    await _questionsDb.insertQuestion(
                      title: title,
                      subject: subject,
                      description: description,
                    );
                  }

                  if (!mounted) {
                    return;
                  }

                  setState(() {});

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing
                            ? 'Question updated successfully.'
                            : 'Question added successfully.',
                      ),
                    ),
                  );
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    _titleController.clear();
    _subjectController.clear();
    _descriptionController.clear();
  }

  Future<void> _deleteQuestion(dynamic id) async {
    try {
      await _questionsDb.deleteQuestion(id);

      if (!mounted) {
        return;
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question deleted successfully.')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Widget _buildEmptyState({
    required String title,
    required String message,
    required IconData icon,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: Colors.indigo),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return _buildEmptyState(
        title: 'Login required',
        message: 'Please log in to manage your questions.',
        icon: Icons.lock_outline,
      );
    }

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _questionsDb.getQuestions(_userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(snapshot.error.toString()),
                  ),
                );
              }

              final questions = snapshot.data ?? [];

              if (questions.isEmpty) {
                return _buildEmptyState(
                  title: 'No questions added yet',
                  message:
                      'Tap the button below to create your first question.',
                  icon: Icons.question_answer_outlined,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final title = question['title'] as String;
                  final subject = question['subject'] as String;

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(title),
                      subtitle: Text(subject),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                _openQuestionDialog(question: question),
                            icon: const Icon(Icons.edit, color: Colors.indigo),
                          ),
                          IconButton(
                            onPressed: () => _deleteQuestion(question['id']),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => _openQuestionDialog(),
            child: const Text(
              'Add New Question',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
