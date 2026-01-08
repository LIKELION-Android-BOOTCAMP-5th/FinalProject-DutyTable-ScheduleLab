import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/notification/presentation/viewmodels/notification_state.dart';
import 'package:dutytable/features/notification/presentation/viewmodels/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllDeleteDialog extends StatelessWidget {
  /// 알림 전체 삭제 다이얼로그
  const AllDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewModel = context.read<NotificationViewModel>();

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.15)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "전체 알림을 삭제하시겠습니까?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain(context),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textSub(context)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "취소",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMain(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          await viewModel.deleteAllNotifications();

                          final hasUnread = await viewModel
                              .hasUnreadNotifications();

                          if (!context.mounted) return;
                          context
                              .read<NotificationState>()
                              .setHasNewNotifications(hasUnread);

                          context.pop(true);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '알림을 모두 삭제했습니다.',
                                style: TextStyle(
                                  color: AppColors.textMain(context),
                                ),
                              ),
                              backgroundColor: AppColors.danger(context),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 20,
                                left: 20,
                                right: 20,
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '알림 삭제 중 오류가 발생했습니다: $e',
                                style: TextStyle(
                                  color: AppColors.textMain(context),
                                ),
                              ),
                              backgroundColor: AppColors.danger(context),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 20,
                                left: 20,
                                right: 20,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.danger(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          "확인",
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
