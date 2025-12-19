import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/widgets/member_invite_dialog/dialog_body.dart';
import 'package:dutytable/features/calendar/presentation/widgets/member_invite_dialog/dialog_button_section.dart';
import 'package:dutytable/features/calendar/presentation/widgets/member_invite_dialog/error_message.dart';
import 'package:dutytable/features/calendar/presentation/widgets/member_invite_dialog/invite_user_tag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/shared_calendar_view_model.dart';
import '../member_select_dialog/dialog_header.dart';

class MemberInviteDialog extends StatelessWidget {
  final SharedCalendarViewModel viewModel;

  /// 공유 캘린더 - 멤버 추가 다이얼로그
  const MemberInviteDialog({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          viewModel.clearError(); // 다이얼로그가 닫힐 때 에러 초기화
        }
      },
      child: ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<SharedCalendarViewModel>(
          builder: (context, viewModel, _) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.background(context),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 멤버 추가 다이얼로그 - 헤더
                    DialogHeader(),

                    const SizedBox(height: 12),

                    /// 멤버 추가 다이얼로그 - 멤버 입력 + 추가 버튼
                    DialogBody(viewModel: viewModel),

                    /// 에러 메시지 (다이얼로그 내부)
                    ErrorMessage(viewModel: viewModel),

                    const SizedBox(height: 16),

                    /// 초대된 멤버
                    if (viewModel.invitedUsers.isNotEmpty)
                      InviteUserTag(viewModel: viewModel),

                    const SizedBox(height: 20),

                    /// 멤버 초대 다이얼로그 - 버튼 세션
                    DialogButtonSection(viewModel: viewModel),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
