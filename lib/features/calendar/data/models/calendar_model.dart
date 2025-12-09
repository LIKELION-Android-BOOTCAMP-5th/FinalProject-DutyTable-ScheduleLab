import 'calendar_member_model.dart';

class CalendarModel {
  final int id;
  final String type;
  final String ownerNickname;
  final String title;
  final String? description;
  final String? imageURL;
  final List<CalendarMemberModel>? calendarMemberModel;
  // final ChatMessageModel? chatMessageModel;

  CalendarModel({
    required this.id,
    required this.type,
    required this.ownerNickname,
    required this.title,
    this.description,
    this.imageURL,
    this.calendarMemberModel,
    // this.chatMessageModel,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    final ownerJson = json['calendars_user_id_fkey'] as Map<String, dynamic>?;
    final String ownerNickname =
        ownerJson?['nickname'] as String? ?? 'Unknown Owner';

    final List<dynamic> membersJson = json['calendar_members'] ?? [];
    final List<CalendarMemberModel> members = membersJson
        .map((m) => CalendarMemberModel.fromJson(m as Map<String, dynamic>))
        .toList();
    return CalendarModel(
      id: json["id"] as int,
      type: json["type"] as String,
      ownerNickname: ownerNickname,
      title: json["title"] as String,
      description: json["description"] as String?,
      imageURL: json["imageURL"] as String?,
      calendarMemberModel: members,
    );
  }
}
