import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class ScheduleAddButtonSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  /// 일정 추가 - 버튼 세션
  const ScheduleAddButtonSection({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            /// 일정 추가 - 취소 버튼
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.card(context),
                  border: Border.all(color: AppColors.commonGrey, width: 1),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "취소",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// 일정 추가 - 저장 버튼
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.actionPositive(context),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "저장",
                    style: TextStyle(
                      color: AppColors.commonWhite,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
