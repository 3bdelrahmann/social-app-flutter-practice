class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;

  UserModel(
    this.name,
    this.email,
    this.phone,
    this.uId,
  );

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
    };
  }
}
