import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:dutytable/features/profile/presentation/widgets/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../calendar/presentation/viewmodels/personal_calendar_view_model.dart';
import '../../../../schedule/data/datasources/schedule_data_source.dart';

class GoogleSyncButton extends StatelessWidget {
  const GoogleSyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewmodel>();
    return CustomTab(
      icon: Icons.settings_outlined,
      buttonText: "구글 캘린더 동기화",
      padding: 7.0,
      addWidget: GestureDetector(
        onTap: () async {
          try {
            if (!viewModel.is_sync) {
              await viewModel.googleSync();
              Fluttertoast.showToast(msg: "구글 캘린더 연동이 완료되었습니다.");
              final googleSchedules = await ScheduleDataSource.instance
                  .syncGoogleCalendarToSchedule();
              await Fluttertoast.showToast(
                msg: "${googleSchedules.length}개의 일정을 가져왔습니다.",
              );
            } else {
              await viewModel.googleSync();
              Fluttertoast.showToast(msg: "구글 캘린더 연동이 해제되었습니다.");
            }
          } catch (e) {
            (!viewModel.is_sync)
                ? Fluttertoast.showToast(msg: "구글 캘린더 연동에 실패했습니다.")
                : Fluttertoast.showToast(msg: "연동 해제에 실패했습니다.");
          }
          await context.read<PersonalCalendarViewModel>().fetchCalendar();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: (viewModel.state == viewState.loading)
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  (viewModel.is_sync) ? "연결해제" : "연결",
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
