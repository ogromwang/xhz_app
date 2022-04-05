// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ProfileResult profileFromJson(String str) => ProfileResult.fromJson(json.decode(str));

String profileToJson(ProfileResult data) => json.encode(data.toJson());

class ProfileResult {
  ProfileResult({
    required this.code,
    required this.data,
    required this.error,
  });

  int code;
  ProfileData data;
  String error;

  factory ProfileResult.fromJson(Map<String, dynamic> json) => ProfileResult(
    code: json["code"],
    data: ProfileData.fromJson(json["data"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
    "error": error,
  };
}

class ProfileData {
  ProfileData({
    required this.id,
    required this.username,
    required this.password,
    required this.profilePicture,
    required this.createAt,
  });

  int id;
  String username;
  String password;
  String profilePicture;
  DateTime createAt;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    username: json["username"],
    password: json["password"],
    profilePicture: json["profile_picture"],
    createAt: DateTime.parse(json["createAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
    "profile_picture": profilePicture,
    "createAt": createAt.toIso8601String(),
  };
}
