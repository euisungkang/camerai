// class User {
//   String? userUUID;
//   String? email;
//
//   UserInformation._privateConstructor();
//
//   static final UserInformation _instance =
//   UserInformation._privateConstructor();
//
//   factory UserInformation() {
//     return _instance;
//   }
//
//   UserInformation.fromJson(Map<String, dynamic> json) {
//     userUUID = json['user_uuid'] as String;
//     nickName = json['nickname'] as String;
//     phoneNumber = json['phone_number'] as String;
//     profileImageUrl = json['profile_image'] as String;
//     gender = json['gender'] as String;
//     purpose = json['purpose'] as int;
//     isMarketingNotificationAllowed = json['marketing_notification'] as bool;
//     isCertificated = json['is_certificated'] as bool;
//
//     if (json['kakao_id'] != null) {
//       userType = "kakao";
//     } else if (json['apple_id'] != null) {
//       userType = "apple";
//     } else {
//       userType = "local";
//     }
//   }
//
//   Map<String, dynamic> toJsonForPatch(
//       String? nickname,
//       String? sector,
//       String? profile_image_url,
//       int? purpose,
//       String? fcm_token,
//       bool? marketing_notification,
//       String? kakao_id,
//       String? apple_id) {
//
//     final Map<String, dynamic> data = <String, dynamic>{};
//
//     data['nickname'] = nickname;
//     data['sector'] = sector;
//     data['profile_image_url'] = profile_image_url;
//     data['purpose'] = purpose;
//     data['fcm_token'] = fcm_token;
//     data['marketing_notification'] = marketing_notification;
//     data['kakao_id'] = kakao_id;
//     data['apple_id'] = apple_id;
//
//     data.removeWhere((k, v) => v == null || v == '' || v == 'null');
//
//     return data;
//   }
// }
//
//
