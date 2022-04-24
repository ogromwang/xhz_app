import 'package:meta/meta.dart';
import 'dart:convert';

GoalResultModel goalResultModelFromJson(String str) => GoalResultModel.fromJson(json.decode(str));

String goalResultModelToJson(GoalResultModel data) => json.encode(data.toJson());

class GoalResultModel {
  GoalResultModel({
    required this.code,
    required this.data,
    required this.error,
  });

  int code;
  List<OneGoal> data;
  String error;

  factory GoalResultModel.fromJson(Map<String, dynamic> json) => GoalResultModel(
    code: json["code"],
    data: List<OneGoal>.from(json["data"].map((x) => OneGoal.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "error": error,
  };
}

class OneGoal {
  OneGoal({
    required this.id,
    required this.name,
    required this.goal,
    required this.currMoney,
    required this.type,
    required this.accountIds,
  });

  int id;
  String name;
  double goal;
  double currMoney;
  int type;
  List<int> accountIds;

  factory OneGoal.fromJson(Map<String, dynamic> json) => OneGoal(
    id: json["Id"],
    name: json["Name"],
    goal: json["Goal"].toDouble(),
    currMoney: json["CurrMoney"].toDouble(),
    type: json["Type"],
    accountIds: List<int>.from(json["AccountIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "Goal": goal,
    "CurrMoney": currMoney,
    "Type": type,
    "AccountIds": List<dynamic>.from(accountIds.map((x) => x)),
  };
}
