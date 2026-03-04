import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class AiSchedule extends StatelessWidget {
  final String? aiScheduleTitle;
  final String aiScheduleDate;
  final String aiScheduleTime;
  final String? aiSchedulePlace;

  const AiSchedule({
    super.key,
    required this.aiScheduleTitle,
    required this.aiScheduleDate,
    required this.aiScheduleTime,
    this.aiSchedulePlace = "(장소 없음)",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.aiInfoBorder(context),
              width: 2.0,
            ),
            color: AppColors.aiInfo(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${aiScheduleTitle} ${aiScheduleDate} ${aiScheduleTime} ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "${aiSchedulePlace} ",
                          style: (aiSchedulePlace == "(장소 없음)")
                              ? TextStyle(color: AppColors.textSub(context))
                              : TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "일정에 추가하시겠습니까?"),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.dialogCloseIcon(context),
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
