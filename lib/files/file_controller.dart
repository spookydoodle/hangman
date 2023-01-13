import 'package:flutter/material.dart';
import 'package:hangman/model/user.dart';
import 'package:hangman/files/file_manager.dart';

// TODO: Why was this file created, can just use file_manager?
class FileController extends ChangeNotifier {
  String _text = '';
  // User _user = User('');
  // Uint8List _imageByteList;

  String get text => _text;
  // User get user => _user;

  // Uint8List get imageByteList => _imageByteList;

  readHeadlineIds() async {
    _text = await FileManager().readHeadlineIds();
    notifyListeners();
  }

  // writeHeadlineId() async {
  //   _text = await FileManager().writeHeadlineId('a');
  //   notifyListeners();
  // }

  // TODO: User data file - pas high scores etc - until saved remotely
  // readUser() async {
  //   _user = User.fromJson(await FileManager().readUser());
  //   notifyListeners();
  // }

  // writeUser() async {
  //   _user = await FileManager().writeUser();
  //   notifyListeners();
  // }

  // readImage() async {
  //   _imageByteList = await FileManager().readImageFile();
  //   notifyListeners();
  // }

  // writeImage() async {
  //   _imageByteList = await FileManager().writeImageFile();
  //   notifyListeners();
  // }

  // deleteImage() async {
  //   FileManager().deleteImage();
  //   _imageByteList = null;
  //   notifyListeners();
  // }
}
