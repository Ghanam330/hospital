import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.password,
    required this.personId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });

  String id;
  String? password;
  String name;
  String email;
  String personId;
  String phone;
  String image;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ,
        personId: json["personId"],
        password: json["password"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personId": personId,
        "password": password,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
      };

  UserModel copyWith({String? name, password, phone}) => UserModel(
        id: id,
        personId: personId,
        name: name ?? this.name,
        email: email,
        password: password ?? this.password,
        phone: phone,
        image: image,
      );
}
