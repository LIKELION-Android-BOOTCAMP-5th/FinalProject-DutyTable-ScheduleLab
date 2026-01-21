import 'calendar_member_entity.dart';

class CalendarEntity {
  final int id;
  final String type;
  final String userId;
  final String ownerNickname;
  final String? ownerProfileUrl;
  final String title;
  final String? description;
  final String? imageUrl;
  final List<CalendarMemberEntity>? members;

  CalendarEntity({
    required this.id,
    required this.type,
    required this.userId,
    required this.ownerNickname,
    required this.ownerProfileUrl,
    required this.title,
    this.description,
    this.imageUrl,
    this.members,
  });

  CalendarEntity copyWith({
    int? id,
    String? type,
    String? userId,
    String? ownerNickname,
    String? ownerProfileUrl,
    String? title,
    String? description,
    String? imageUrl,
    List<CalendarMemberEntity>? members,
    bool clearImageUrl = false,
  }) {
    return CalendarEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      ownerNickname: ownerNickname ?? this.ownerNickname,
      ownerProfileUrl: ownerProfileUrl ?? this.ownerProfileUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      members: members ?? this.members,
    );
  }
}
