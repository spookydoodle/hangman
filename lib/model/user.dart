class User {
  final String name;
  // TODO: add scores

  User(this.name);

  User.fromJson(Map<String, dynamic> json) : name = json['name'];
}
