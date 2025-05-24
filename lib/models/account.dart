import 'dart:convert';

class Account {
  final String uuid;
  String? apiId;
  int? userLevel;
  String? apiName;
  String? apiEmail;
  String? apiPhotoUrl;
  int? isSignedIn;
  int? isPublic;
  int? isContributorMode;
  int? isRestricted;
  int? isSynchronized;
  String? ttl;
  final String createdAt;

  Account({
    required this.uuid,
    this.apiId,
    this.userLevel,
    this.apiName,
    this.apiEmail,
    this.apiPhotoUrl,
    this.isSignedIn,
    this.isPublic,
    this.isContributorMode,
    this.isRestricted,
    this.isSynchronized,
    this.ttl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'api_id': apiId,
      'user_level': userLevel,
      'api_name': apiName,
      'api_email': apiEmail,
      'api_photo_url': apiPhotoUrl,
      'is_signed_in': isSignedIn,
      'is_public': isPublic,
      'is_contributor_mode': isContributorMode,
      'is_restricted': isRestricted,
      'is_synchronized': isSynchronized,
      'ttl': ttl,
      'created_at': createdAt,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        uuid: map['uuid'] ?? '',
        apiId: map['api_id'] ?? '',
        userLevel: map['user_level']?.toInt() ?? 0,
        apiName: map['api_name'] ?? '',
        apiEmail: map['api_email'] ?? '',
        apiPhotoUrl: map['api_photo_url'] ?? '',
        isSignedIn: map['is_signed_in']?.toInt() ?? 0,
        isPublic: map['is_public']?.toInt() ?? 0,
        isContributorMode: map['is_contributor_mode']?.toInt() ?? 0,
        isRestricted: map['is_restricted']?.toInt() ?? 0,
        isSynchronized: map['is_synchronized']?.toInt() ?? 0,
        ttl: map['ttl'] ?? '',
        createdAt: map['created_at'] ?? '',
      );
    }

    String toJson() => json.encode(toMap());

    factory Account.fromJson(String source) => Account.fromMap(json.decode(source));

  @override
  String toString() {
    return '''
  {
    "uuid": "$uuid",
    "api_id": "$apiId",
    "user_level": $userLevel,
    "api_name": "$apiName",
    "api_email": "$apiEmail",
    "api_photo_url": "$apiPhotoUrl",
    "is_signed_in": $isSignedIn,
    "is_public": $isPublic,
    "is_contributor_mode": $isContributorMode,
    "is_restricted": $isRestricted,
    "is_synchronized": $isSynchronized,
    "ttl": "$ttl",
    "created_at": "$createdAt"
  }
  ''';
    }

}
