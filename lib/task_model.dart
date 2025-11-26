class Task {
  final int id;
  final String title;
  final String? content;
  final String? started_at;
  final String? ended_at;
  final String created_at;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.started_at,
    required this.ended_at,
    required this.created_at,
  });

  // Supabase 응답 데이터를 Player 객체로 변환하는 팩토리 생성자
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      started_at: json['started_at'] as String?,
      ended_at: json['ended_at'] as String?,
      created_at: json['created_at'] as String,
    );
  }
}
