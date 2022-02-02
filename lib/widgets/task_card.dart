import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
      {Key? key, this.title = "(Unnamed)", this.subtitle = "(Nothing here)"})
      : super(key: key);
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        color: Colors.grey.shade200,
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}
