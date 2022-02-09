import 'package:ParkShield/screens/nominee/nominee_page_body.dart';
import 'package:ParkShield/widgets/drawer.dart';
import 'package:flutter/material.dart';

class NomineePage extends StatefulWidget {
  const NomineePage({Key? key}) : super(key: key);

  @override
  State<NomineePage> createState() => _NomineePageState();
}

class _NomineePageState extends State<NomineePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: AppBar(
        title: Text(
          'Nominees to vehicles',
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 32,
              ),
        ),
        centerTitle: true,
      ),
      body: const NomineePageBody(),
    );
  }
}
