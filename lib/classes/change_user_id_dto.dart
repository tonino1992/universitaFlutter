class ChangeUserIdDto {
  final String oldUserId;
  final String newUserId;

  ChangeUserIdDto({
    required this.oldUserId,
    required this.newUserId,
  });

  ChangeUserIdDto.fromJson(Map<String, dynamic> json)
      : oldUserId = json['oldUserId'] as String,
        newUserId = json['newUserId'] as String;

  Map<String, dynamic> toJson() => {
        'oldUserId': oldUserId,
        'newUserId': newUserId,
      };
}
