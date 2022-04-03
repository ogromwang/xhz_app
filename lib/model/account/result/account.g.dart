// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountFriendResult _$AccountFriendResultFromJson(Map<String, dynamic> json) {
  return AccountFriendResult(
    json['code'] as int,
    json['data'] == null
        ? AccountFriendResultData([], 0)
        : AccountFriendResultData.fromJson(
            json['data'] as Map<String, dynamic>),
    json['error'] as String,
  );
}

Map<String, dynamic> _$AccountFriendResultToJson(
        AccountFriendResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'error': instance.error,
    };

AccountFriendResultData _$AccountFriendResultDataFromJson(
    Map<String, dynamic> json) {
  return AccountFriendResultData(
    (json['list'] as List).map((e) => AccountFriendResultDataList.fromJson(e as Map<String, dynamic>)).toList(),
    json['total'] as int,
  );
}

Map<String, dynamic> _$AccountFriendResultDataToJson(
        AccountFriendResultData instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
    };

AccountFriendResultDataList _$AccountFriendResultDataListFromJson(
    Map<String, dynamic> json) {
  return AccountFriendResultDataList(
    json['id'] as int,
    json['username'] as String,
    json['password'] as String,
    json['profile_picture'] as String,
    json['createAt'] as String,
  );
}

Map<String, dynamic> _$AccountFriendResultDataListToJson(
        AccountFriendResultDataList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'password': instance.password,
      'profile_picture': instance.profilePicture,
      'createAt': instance.createAt,
    };
