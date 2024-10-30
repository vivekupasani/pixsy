class Appuser {
  final String name;
  final String email;
  final String uid;

  Appuser({required this.email, required this.name, required this.uid});

  // Static method to convert an Appuser instance to JSON
  static Map<String, dynamic> toJson(Appuser user) {
    return {"email": user.email, "uid": user.uid, "name": user.name};
  }

  // Convert JSON to Appuser
  factory Appuser.fromJson(Map<String, dynamic> jsonUser) {
    return Appuser(
        email: jsonUser['email'], name: jsonUser['name'], uid: jsonUser['uid']);
  }
}
