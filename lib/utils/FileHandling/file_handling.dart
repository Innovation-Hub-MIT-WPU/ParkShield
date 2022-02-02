import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

// Get the local app documents' path
Future<String> get _localAppDocPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// Get File from app documents directory
Future<File> _getFileAD({required String filename}) async {
  final String appDocPath = await _localAppDocPath;
  return File("$appDocPath/$filename");
}

// Write to a file
Future<bool> writeToFile(
    {required String filename,
    required String content,
    String mode = "w"}) async {
  File file = await _getFileAD(filename: "$filename");

  if (mode == "a") {
    return ("${file.path}" ==
        (await file.writeAsString(content, mode: FileMode.append)).path);
  }

  return ("${file.path}" == (await file.writeAsString(content)).path);
}

// Read from a file
Future<dynamic> readFromFile({required String filename}) async {
  File file = await _getFileAD(filename: "$filename");
  late dynamic content = {};

  // .json extension
  if (filename.endsWith(".json")) {
    final String stringData = await file.readAsString();
    content = json.decode(stringData) as Map<String, dynamic>;
    print(content);
  }
  // .txt extension
  else if (filename.endsWith(".txt")) {
    final String stringData = await file.readAsString();
    content = stringData;
  }
  return content;
}
