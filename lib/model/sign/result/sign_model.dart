import 'dart:convert';

LoginModelResult signModelFromJson(String str) => LoginModelResult.fromJson(json.decode(str));

String signModelToJson(LoginModelResult data) => json.encode(data.toJson());

class LoginModelResult {
  LoginModelResult({
    required this.code,
    required this.data,
    required this.error,
  });

  int code;
  String data;
  String error;

  factory LoginModelResult.fromJson(Map<String, dynamic> json) => LoginModelResult(
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

class SignupModelResult {
  SignupModelResult({
    required this.code,
    required this.data,
    required this.error,
  });

  int code;
  bool data;
  String error;

  factory SignupModelResult.fromJson(Map<String, dynamic> json) => SignupModelResult(
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
