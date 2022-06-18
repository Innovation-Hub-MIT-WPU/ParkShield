import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.singleButton = '',
  }) : super(key: key);
  final String title;
  final String content, singleButton;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    if (singleButton == 'popBack') {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        scrollable: true,
        backgroundColor: Colors.grey.shade300,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ),
        actions: actions,
        content: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.grey.shade200,
          child: Text(
            content,
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    } else {
      return AlertDialog(
        scrollable: true,
        backgroundColor: Colors.grey.shade300,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ),
        actions: actions,
        content: SizedBox(
          width: screenWidth / 5,
          height: screenHeight / 20,
          child: const Text(
            'Hi',
          ),
        ),
      );
    }
  }
}
