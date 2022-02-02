import 'package:ParkShield/utils/FileHandling/file_handling.dart';

Future<Map<String, dynamic>> getListOfItems() async {
  late Map<String, dynamic> list = {};
  try {
    list = await readFromFile(filename: "lists.json");
  } catch (e) {
    print(e);
  }

  return list;
}
