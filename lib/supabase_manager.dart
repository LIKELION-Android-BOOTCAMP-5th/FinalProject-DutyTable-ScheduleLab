import 'package:dutytable/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  // 이유 - 밖에서 shared를 null등 건드리지 못하게
  // 오 일단 생성이 되었다.
  static final SupabaseManager _shared = SupabaseManager();
  static SupabaseManager get shared => _shared;

  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  SupabaseManager() {
    debugPrint("SupabaseManager init");
  }

  Future<List<Task>> fetchTasks() async {
    final data = await supabase.from('tasks').select();

    final List<Task> results = data.map((Map<String, dynamic> json) {
      return Task.fromJson(json);
    }).toList();

    return results;
  }
}
