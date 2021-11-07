class Keyword {
  String text = "";
  String url = "";

  Keyword(this.text, this.url);
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
    data['id'] = this.id;
    data['category'] = this.category;
    data['country'] = this.country;
    data['lang'] = this.lang;
    data['headline'] = this.headline;
    data['provider'] = this.provider;
    data['url'] = this.url;
    data['age'] = this.age;
    data['timestamp'] = this.timestamp;

    return data;
  }
}
