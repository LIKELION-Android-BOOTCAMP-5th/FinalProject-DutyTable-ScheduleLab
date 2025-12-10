import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:flutter/material.dart';

/// TODO
/// 일정 상세 UI 추가
/// 지도 API 연동하여 주소가 있을 시 지도와 마커 추가
class ScheduleDetailScreen extends StatelessWidget {
  const ScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackActionsAppBar(title: Text("병원예약")),
      body: SafeArea(child: Center(child: Text("디테일 화면"))),
    );
  }
}
