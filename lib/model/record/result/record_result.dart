// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RecordResult recordResultFromJson(String str) => RecordResult.fromJson(json.decode(str));

String recordResultToJson(RecordResult data) => json.encode(data.toJson());

class RecordResult {
  RecordResult({
    required this.code,
    required this.data,
    required this.error,
  });

  int code;
  Data data;
  String error;

  factory RecordResult.fromJson(Map<String, dynamic> json) => RecordResult(
    code: json["code"],
    data: Data.fromJson(json["data"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
    "error": error,
  };
}

class Data {
  Data({
    required this.list,
    required this.more,
  });

  List<Item> list;
  bool more;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    list: List<Item>.from(json["list"].map((x) => Item.fromJson(x))),
    more: json["more"],
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "more": more,
  };
}

class Item {
  Item({
    required this.createdAt,
    required this.id,
    required this.share,
    required this.money,
    required this.describe,
    required this.image,
    required this.accountId,
    required this.username,
    required this.profilePicture,
  });

  DateTime createdAt;
  int id;
  bool share;
  double money;
  String describe;
  String image;
  int accountId;
  String username;
  String profilePicture;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    createdAt: DateTime.parse(json["createdAt"]),
    id: json["id"],
    share: json["share"],
    money: json["money"].toDouble(),
    describe: json["describe"],
    image: json["image"],
    accountId: json["accountId"],
    username: json["username"],
    profilePicture: json["profilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "id": id,
    "share": share,
    "money": money,
    "describe": describe,
    "image": image,
    "accountId": accountId,
    "username": username,
    "profilePicture": profilePicture,
  };
}
