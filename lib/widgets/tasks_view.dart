import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ParkShield/services/List/list_operations.dart';
import 'package:ParkShield/widgets/task_card.dart';

class TaskView extends StatefulWidget {
  const TaskView({Key? key}) : super(key: key);

  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late Map<String, dynamic> titleSubtitle, tempTitleSubtitle;
  late Timer timerActivity;
  late List<TaskCard> tasks, tempTasks;

  @override
  void initState() {
    Timer.periodic(
        const Duration(seconds: 5), (timerActivity) => {updateList()});
    tasks = tempTasks = [];
    titleSubtitle = tempTitleSubtitle = {};
    super.initState();
  }

  void updateList() async {
    tempTitleSubtitle.clear();
    tempTasks.clear();

    try {
      tempTitleSubtitle = await getListOfItems();
    } catch (e) {
      print(e);
      return;
    }

    if (titleSubtitle == tempTitleSubtitle) {
      print(titleSubtitle == tempTitleSubtitle);
      return;
    }
    tempTitleSubtitle.forEach(
      (k, v) => tempTasks.add(
        TaskCard(
          title: k,
          subtitle: v,
        ),
      ),
    );

    setState(() {
      tasks = tempTasks;
      titleSubtitle = tempTitleSubtitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: tasks,
      ),
    );
  }
}
