import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {
  // static FileManager _instance = new FileManager();
  //
  // FileManager._internal() {
  //   _instance = this;
  // }
  //
  // factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _textFile async {
    final path = await _localPath;
    return File('$path/headline.txt');
  }

  Future<File> get _jsonFile async {
    final path = await _localPath;
    return File('$path/settings.json');
  }

  Future<String> readHeadlineIds() async {
    try {
      final file = await _textFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      print(e.toString());
      return '';
    }
  }

  Future<File> writeHeadline(String id) async {
    final file = await _textFile;

    // Write the file
    return file.writeAsString('${id};', mode: FileMode.append);
  }

  Future<Map<String, dynamic>> readJsonFile() async {
    String fileContent = 'Cheetah Coding';

    File file = await _jsonFile;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return json.decode(fileContent);
      } catch (e) {
        print(e);
      }
    }

    return {};
  }

  Future<Map<String, dynamic>> writeJsonFile(String category, String country) async {
    final Map<String, dynamic> settings = {
      "category": category,
      "country": country
    };

    File file = await _jsonFile;
    await file.writeAsString(json.encode(settings));
    return settings;
  }
}
