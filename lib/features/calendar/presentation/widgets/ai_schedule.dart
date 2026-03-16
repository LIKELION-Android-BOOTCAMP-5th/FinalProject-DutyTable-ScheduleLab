import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class AiSchedule extends StatelessWidget {
  final String? aiScheduleTitle;
  final String aiScheduleDate;
  final String aiScheduleTime;
  final String? aiSchedulePlace;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const AiSchedule({
    super.key,
    required this.aiScheduleTitle,
    required this.aiScheduleDate,
    required this.aiScheduleTime,
    this.aiSchedulePlace = "(장소 없음)",
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.aiInfoBorder(context),
              width: 1.0,
            ),
            color: AppColors.background(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      if (aiScheduleTitle?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            aiScheduleTitle!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain(context),
                            ),
                          ),
                        ),
                      // 날짜 · 시간 (필수값)
                      Text(
                        '$aiScheduleDate · $aiScheduleTime',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain(context),
                        ),
                      ),
                      // 장소
                      if (aiSchedulePlace != null && aiSchedulePlace != "(장소 없음)")
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            aiSchedulePlace!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSub(context),
                            ),
                          ),
                        ),
                      // 질문
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "일정에 추가하시겠습니까?",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSub(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.dialogCloseIcon(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
