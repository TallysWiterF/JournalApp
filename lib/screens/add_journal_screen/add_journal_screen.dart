import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  AddJournalScreen({super.key, required this.journal});

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getJournalDate),
        actions: [
          IconButton(
              onPressed: () {
                journal.content = _contentController.text;
                registerJournal(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  String get getJournalDate => WeekDay(journal.createdAt).toString();

  registerJournal(BuildContext context) async {
    JournalService service = JournalService();
    Navigator.pop(context, await service.register(journal));
  }
}
