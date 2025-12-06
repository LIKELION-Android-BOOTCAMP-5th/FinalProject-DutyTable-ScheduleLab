import 'package:flutter/material.dart';

class SharedCalendarViewModel extends ChangeNotifier {
  bool deleteMode = false;
  bool isAdmin = false;

  /// 선택된 카드 id들
  final Set<String> selectedIds = {};

  void toggleDeleteMode() {
    deleteMode = !deleteMode;
    notifyListeners();
  }

  void cancelDeleteMode() {
    deleteMode = false;
    selectedIds.clear();
    notifyListeners();
  }

  /// 특정 카드 선택 토글
  void toggleSelected(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  /// 특정 카드가 선택됐는지 여부
  bool isSelected(String id) {
    return selectedIds.contains(id);
  }

  void setAdmin(bool value) {
    isAdmin = value;
    notifyListeners();
  }
}
