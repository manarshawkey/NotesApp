import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'utils.dart' as utils;
import 'notes/Notes.dart';

void main() {
  startMeUp() async {
    var ensureInitialized = WidgetsFlutterBinding.ensureInitialized();
    if(ensureInitialized != null) {
      Directory docsDir = await getApplicationDocumentsDirectory();
      utils.docsDir = docsDir;
    }
    runApp(FlutterBook());
  }
  startMeUp();
  //runApp(FlutterBook());
}
class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text('FlutterBook'),
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.date_range),
                    text: 'Appointments',
                  ),
                  Tab(
                    icon: Icon(Icons.contact_phone),
                    text: 'Contacts',
                  ),
                  Tab(
                    icon: Icon(Icons.notes),
                    text: 'Notes',
                  ),
                  Tab(
                    icon: Icon(Icons.assignment_turned_in),
                    text: 'Tasks',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Notes(), Notes(), Notes(), Notes(),
              ],
            ),
          ),
      ),
    );
  }
}


