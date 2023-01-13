class Keyword {
  int id;
  String text;
  String url;
  int maxMistakes;

  Keyword({required this.id, required this.text, required this.url, required this.maxMistakes});
}

class HeadlineModel {
  int id = 0;
  String category = "";
  String country = "";
  String lang = "";
  String headline = "";
  String provider = "";
  String url = "";
  String age = "";
  String timestamp = "";

  HeadlineModel(
      {required this.id,
      required this.category,
      required this.country,
      required this.lang,
      required this.headline,
      required this.provider,
      required this.url,
      required this.age,
      required this.timestamp});

  HeadlineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    country = json['country'];
    lang = json['lang'];
    headline = json['headline'];
    provider = json['provider'];
    url = json['url'];
    age = json['age'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['category'] = category;
    data['country'] = country;
    data['lang'] = lang;
    data['headline'] = headline;
    data['provider'] = provider;
    data['url'] = url;
    data['age'] = age;
    data['timestamp'] = timestamp;

    return data;
  }
}
