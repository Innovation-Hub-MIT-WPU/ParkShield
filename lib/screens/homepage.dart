import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ParkShield/widgets/drawer.dart';
import 'package:ParkShield/widgets/tasks_view.dart';
import 'package:ParkShield/services/FileHandling/file_handling.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TaskView tasks;
  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      updateList();
    });
    tasks = const TaskView();

    super.initState();
  }

  void updateList() {
    tasks = const TaskView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.getFont('Lato'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await writeToFile(
              filename: "lists.json",
              content: "{\"Title\":\"Subtitle\"}",
              mode: "w");
        },
        child: const Icon(Icons.add),
      ),
      body: tasks,
    );
  }
}
