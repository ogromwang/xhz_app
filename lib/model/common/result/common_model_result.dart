import 'dart:convert';

class BoolModelResult {
  BoolModelResult({
    required this.code,
    required this.data,
    required this.error,
  });

  int code;
  bool data;
  String error;

  factory BoolModelResult.fromJson(Map<String, dynamic> json) => BoolModelResult(
    code: json["code"],
    data: json["data"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data,
    "error": error,
  };
}
