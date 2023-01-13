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

  Future<File> get _headlineIdsTextFile async {
    final path = await _localPath;
    final file = File('$path/headline.txt');
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    return file;
  }

  Future<File> get _settingsJsonFile async {
    final path = await _localPath;
    final file = File('$path/settings.json');
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    return file;
  }

  Future<String> readHeadlineIds() async {
    try {
      final file = await _headlineIdsTextFile;
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<File> writeHeadlineId(String id) async {
    final file = await _headlineIdsTextFile;

    return file.writeAsString('$id;', mode: FileMode.append);
  }

  Future<Map<String, dynamic>> readSettings() async {
    File file = await _settingsJsonFile;

    if (await file.exists()) {
      try {
        final fileContent = await file.readAsString();
        return json.decode(fileContent);
      } catch (e) {
        print(e);
      }
    }

    return {};
  }

  Future<Map<String, dynamic>> writeSettings(String category, String country) async {
    final Map<String, dynamic> settings = {
      "category": category,
      "country": country
    };

    File file = await _settingsJsonFile;
    await file.writeAsString(json.encode(settings));
    return settings;
  }
}
