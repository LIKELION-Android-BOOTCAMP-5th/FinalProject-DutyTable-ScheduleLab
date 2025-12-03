import 'package:flutter/material.dart';

/// 개인 캘린더 뷰모델
class PersonalCalendarViewModel extends ChangeNotifier {
  /// 개인 캘린더 탭 이름 리스트(local)
  final List<String> _tabNames = ["캘린더", "리스트", "나와의 채팅"];

  /// 개인 캘린더 탭 이름 리스트(public)
  List<String> get tabNames => _tabNames;

  /// 탭 갯수(public) = 탭 이름 리스트 길이
  int get tabLength => _tabNames.length;

  /// 현재 선택 된 탭의 인덱스(local)
  int _currentIndex = 0;

  /// 현재 선택 된 탭의 인덱스(public)
  int get currentIndex => _currentIndex;

  /// 각 탭 눌렀을 때 실행 할 함수
  void onTabChanged(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      print('탭 클릭 $index');
    }
  }
}
