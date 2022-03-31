import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountFriendResult extends Object {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  AccountFriendResultData data;

  @JsonKey(name: 'error')
  String error;

  AccountFriendResult(this.code,this.data,this.error,);

  factory AccountFriendResult.fromJson(Map<String, dynamic> srcJson) => _$AccountFriendResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccountFriendResultToJson(this);

}


@JsonSerializable()
class AccountFriendResultData extends Object {

  @JsonKey(name: 'list')
  List<AccountFriendResultDataList> list;

  @JsonKey(name: 'total')
  int total;

  AccountFriendResultData(this.list,this.total,);

  factory AccountFriendResultData.fromJson(Map<String, dynamic> srcJson) => _$AccountFriendResultDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccountFriendResultDataToJson(this);

}


@JsonSerializable()
class AccountFriendResultDataList extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'profile_picture')
  String profilePicture;

  @JsonKey(name: 'createAt')
  String createAt;

  AccountFriendResultDataList(this.id,this.username,this.password,this.profilePicture,this.createAt,);

  factory AccountFriendResultDataList.fromJson(Map<String, dynamic> srcJson) => _$AccountFriendResultDataListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccountFriendResultDataListToJson(this);

}



  
