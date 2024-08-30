import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();

  JournalService service = JournalService();

  int? userId;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Título basado no dia atual
          title: Text(
        "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
      )),
      body: (userId != null)
          ? RefreshIndicator(
              color: Colors.amber[800],
              onRefresh: () async {
                refresh();
              },
              child: ListView(
                controller: _listScrollController,
                children: generateListJournalCards(
                    windowPage: windowPage,
                    currentDay: currentDay,
                    database: database,
                    refreshFunction: refresh,
                    userId: userId!),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void refresh() {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString("accessToken");
      String? email = prefs.getString("email");
      int? id = prefs.getInt("id");

      if (token == null || email == null || id == null) {
        Navigator.pushReplacementNamed(context, "login");
      }

      setState(() {
        userId = id;
      });

      service.getAll(id: id!, token: token!).then((List<Journal> listJournal) {
        setState(() {
          database = {};
          for (Journal journal in listJournal) {
            database[journal.id] = journal;
          }
        });
      });
    });
  }
}
