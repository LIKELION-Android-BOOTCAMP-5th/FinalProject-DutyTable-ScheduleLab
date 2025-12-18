import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final int calendarId;

  /// 커스텀 플로팅 액션 버튼(제스처 디텍터 사용)
  const CustomFloatingActionButton({super.key, required this.calendarId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await context.push(
          "/schedule/add",
          extra: {"calendarId": calendarId},
        );

        if (result == true && context.mounted) {
          context.read<ScheduleViewModel>().fetchSchedules();
        }
      },
      child: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // 버튼 내부에 아이콘을 중앙에 배치합니다.
        child: const Center(child: Icon(Icons.add, color: Colors.white)),
      ),
    );
  }
}
