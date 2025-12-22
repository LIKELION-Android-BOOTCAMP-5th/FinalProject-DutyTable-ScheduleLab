import 'package:flutter/material.dart';

class NotificationState extends ChangeNotifier {
  bool _hasNewNotifications = false;
  bool get hasNewNotifications => _hasNewNotifications;

  void setHasNewNotifications(bool value) {
    if (_hasNewNotifications == value) return;
    _hasNewNotifications = value;
    debugPrint("NotificationState set to: $value");
    notifyListeners();
  }
}
