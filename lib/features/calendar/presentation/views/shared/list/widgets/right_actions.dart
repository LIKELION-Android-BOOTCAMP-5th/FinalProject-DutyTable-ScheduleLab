import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/notification/presentation/widgets/notification_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RightActions extends StatelessWidget {
  const RightActions({super.key});

  @override
  Widget build(BuildContext context) {
    final deleteMode = context.select<SharedCalendarViewModel, bool>(
      (viewModel) => viewModel.deleteMode,
    );

    return deleteMode ? const _DeleteModeActions() : const _NormalActions();
  }
}

class _DeleteModeActions extends StatelessWidget {
  /// 공유 캘린더 목록 - 앱바 : 삭제 모드
  const _DeleteModeActions({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SharedCalendarViewModel>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: viewModel.cancelDeleteMode,
          child: Text(
            "취소",
            style: TextStyle(color: AppColors.textSub(context)),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: viewModel.outSelectedCalendars,
          child: Text("삭제", style: TextStyle(color: AppColors.danger(context))),
        ),
      ],
    );
  }
}

class _NormalActions extends StatelessWidget {
  /// 공유 캘린더 목록 - 앱바 : 일반 모드
  const _NormalActions({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SharedCalendarViewModel>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 캘린더 추가 버튼
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            onTap: () async {
              final result = await context.push<bool>("/calendar/add");

              if (result == true) {
                context.read<SharedCalendarViewModel>().fetchCalendars();
              }
            },
            child: Icon(Icons.add, color: AppColors.pureWhite),
          ),
        ),

        const SizedBox(width: 16),

        /// 알림 화면 이동 버튼
        const NotificationIcon(),

        const SizedBox(width: 16),

        /// 캘린더 삭제 모드 버튼
        GestureDetector(
          onTap: () => viewModel.toggleDeleteMode(),
          child: Icon(
            Icons.delete_outline,
            size: 26,
            color: AppColors.textMain(context),
          ),
        ),
      ],
    );
  }
}
