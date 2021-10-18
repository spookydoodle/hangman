class User {
  final String name;
  // TOOD: add scores

  User(this.name);

  User.fromJson(Map<String, dynamic> json) : name = json['name'];
}
