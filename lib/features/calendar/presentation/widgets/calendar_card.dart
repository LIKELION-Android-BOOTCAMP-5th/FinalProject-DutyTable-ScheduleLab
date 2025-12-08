import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final String title;
  final bool deleteMode;
  final bool isAdmin;
  final bool isSelected;
  final VoidCallback onChangeSelected;

  const CalendarCard({
    super.key,
    required this.title,
    required this.deleteMode,
    required this.isAdmin,
    required this.isSelected,
    required this.onChangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final applyBlur = deleteMode && isAdmin;

    return Stack(
      children: [
        Card(
          elevation: 2,
          color: AppColors.card(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected && !applyBlur
                  ? AppColors.commonRed
                  : AppColors.cardBorder(context),
              width: isSelected && !applyBlur ? 2 : 1,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    /// 카드 아바타 이미지 배경색
                    color: const Color(0xFF3A7BFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    "assets/images/calendar_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.chip(context),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "99+명",
                              style: TextStyle(
                                color: AppColors.chipText(context),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "다음 일정: 12월 5일",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.commonGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                if (!deleteMode)
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "99+",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  !isAdmin
                      ? Checkbox(
                          value: isSelected,
                          activeColor: AppColors.commonRed,
                          onChanged: (_) => onChangeSelected(),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chip(context),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "삭제 불가",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.chipText(context),
                            ),
                          ),
                        ),
              ],
            ),
          ),
        ),

        if (applyBlur)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.cardBlur(context),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
