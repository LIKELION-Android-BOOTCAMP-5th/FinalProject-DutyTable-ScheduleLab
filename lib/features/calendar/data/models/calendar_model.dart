import '../../domain/entities/calendar_entity.dart';
import 'calendar_member_model.dart';

class CalendarModel extends CalendarEntity {
  CalendarModel({
    required super.id,
    required super.type,
    required super.userId,
    required super.ownerNickname,
    required super.ownerProfileUrl,
    required super.title,
    super.description,
    super.imageUrl,
    super.members,
  });

  factory CalendarModel.fromJson(
    Map<String, dynamic> json, {
    List<CalendarMemberModel>? members,
  }) {
    final ownerJson = json['calendars_user_id_fkey'] as Map<String, dynamic>?;

    return CalendarModel(
      id: json["id"] as int,
      type: json["type"] as String,
      userId: json["user_id"] as String,
      ownerNickname: ownerJson?['nickname'] as String? ?? 'Unknown Owner',
      ownerProfileUrl: ownerJson?['profile_url'] as String?,
      title: json["title"] as String,
      description: json["description"] as String?,
      imageUrl: json["imageURL"] as String?,
      members: members,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'user_id': userId,
      'title': title,
      'description': description,
      'imageURL': imageUrl,
    };
  }
}
