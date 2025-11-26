import 'package:dutytable/task_model.dart';
import 'package:flutter/material.dart';

class CalendarViewModel extends ChangeNotifier {
  DateTime selectedDay = DateTime.now(); // 클릭한 날짜
  List<Task> _tasks = []; // 일정 리스트
  List<Task> get tasks => _tasks; // 일정 리스트

  List<DateTime?> _tasksDate = []; // 일정 날짜만 담을 리스트
  List<DateTime?> get tasksDate => _tasksDate; // 일정 날짜만 담을 리스트

  void changeSelectedDay(DateTime select) {
    selectedDay = select;
    notifyListeners();
  }

  // 앱 실행될 때
  // supabase에서 데이터 가져오는 함수 실행
  CalendarViewModel() {
    // _initTasks();
  }

  // 앱 실행될 때 supabase에서 데이터 가져오는 함수
  // Future<void> _initTasks() async {
  //   _tasks = await SupabaseManager.shared.fetchTasks();
  //   _tasksDate = _tasks.map((e) {
  //     return e.started_at?.toDateOnlyDateTimeOrNull();
  //   }).toList();
  //
  //   notifyListeners();
  // }
}
