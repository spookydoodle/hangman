import 'dart:convert';
import 'package:hangman/model/headline_model.dart';
import 'package:hangman/settings/settings.dart';
import 'package:http/http.dart';

// Get from https://felidae.spookydoodle.com/news/${category}?cc=${country}&sortBy=timestamp desc&page=${page}
// category = { general, business, sport, entertainment, health, science }
// lang (cc) = { en (gb), en (us), de (de), nl (nl), pl (pl) }
// Create object in memory to store id's which user was already processed (shown to guess or rejected due to length)
class HeadlineNetwork {
  Future<List<HeadlineModel>> getHeadlines({required Function getPage}) async {
    var baseUrl = 'https://felidae.spookydoodle.com/news/${Settings.category}';
    var query = 'cc=${Settings.country}&sortBy=timestamp desc&page=${getPage()}';
    var finalUrl = '${baseUrl}?${query}';

    final response = await get(Uri.parse(finalUrl));
    print('URL: ${Uri.encodeFull(finalUrl)}');

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      List<HeadlineModel> headlines = List<HeadlineModel>.from(list.map((headline)=> HeadlineModel.fromJson(headline)));

      return headlines;
    } else {
      throw Exception('Error getting headlines data');
    }
  }
}
