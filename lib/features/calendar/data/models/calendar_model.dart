import 'calendar_member_model.dart';

class CalendarModel {
  final int id;
  final String type;
  final String userId;
  final String ownerNickname;
  final String? ownerProfileUrl;
  final String title;
  final String? description;
  final String? imageURL;
  List<CalendarMemberModel>? calendarMemberModel;
  List<Map<String, dynamic>>? schedules;

  CalendarModel({
    required this.id,
    required this.type,
    required this.userId,
    required this.ownerNickname,
    required this.title,
    this.description,
    this.imageURL,
    this.calendarMemberModel,
    required this.ownerProfileUrl,
    this.schedules,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    // 방장 데이터
    final ownerJson = json['calendars_user_id_fkey'] as Map<String, dynamic>?;

    // 방장 닉네임
    final String ownerNickname =
        ownerJson?['nickname'] as String? ?? 'Unknown Owner';

    // 방장 프사
    final String? ownerProfileUrl = ownerJson?['profileurl'] as String?;

    // 멤버 데이터
    final List<dynamic> membersJson = json['calendar_members'] ?? [];

    // 멤버 데이터 파싱
    final List<CalendarMemberModel> members = membersJson
        .map((m) => CalendarMemberModel.fromJson(m as Map<String, dynamic>))
        .toList();

    return CalendarModel(
      id: json["id"] as int,
      type: json["type"] as String,
      userId: json["user_id"] as String,
      ownerNickname: ownerNickname,
      title: json["title"] as String,
      description: json["description"] as String?,
      imageURL: json["imageURL"] as String?,
      calendarMemberModel: members.isNotEmpty ? members : null,
      ownerProfileUrl: ownerProfileUrl,
      schedules: json["schedules"] != null
          ? List<Map<String, dynamic>>.from(json["schedules"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'user_id': userId,
      'ownerNickname': ownerNickname,
      'title': title,
      'description': description,
      'imageURL': imageURL,
      'calendarMemberModel': calendarMemberModel
          ?.map((e) => e.toJson())
          .toList(),
      'ownerProfileUrl': ownerProfileUrl,
      'schedules': schedules,
    };
  }

  CalendarModel copyWith({
    int? id,
    String? type,
    String? user_id,
    String? ownerNickname,
    String? ownerProfileUrl,
    String? title,
    String? description,
    String? imageURL,
    List<CalendarMemberModel>? calendarMemberModel,
    List<Map<String, dynamic>>? schedules,
  }) {
    return CalendarModel(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: user_id ?? this.userId,
      ownerNickname: ownerNickname ?? this.ownerNickname,
      ownerProfileUrl: ownerProfileUrl ?? this.ownerProfileUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      imageURL: imageURL,
      calendarMemberModel: calendarMemberModel ?? this.calendarMemberModel,
      schedules: schedules ?? this.schedules,
    );
  }
}
