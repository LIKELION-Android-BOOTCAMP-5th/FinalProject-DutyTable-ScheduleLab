import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/shared_calendar_view_model.dart';

class CalendarCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool deleteMode;
  final bool isAdmin;
  final bool isSelected;
  final int members;
  final VoidCallback onChangeSelected;
  final int? calendarId;

  const CalendarCard({
    super.key,
    required this.title,
    this.imageUrl,
    required this.deleteMode,
    required this.isAdmin,
    required this.isSelected,
    required this.members,
    required this.onChangeSelected,
    this.calendarId,
  });

  @override
  Widget build(BuildContext context) {
    final applyBlur = deleteMode && isAdmin;

    return Stack(
      children: [
        Card(
          elevation: 2,
          color: AppColors.surface(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected && !applyBlur
                  ? AppColors.danger(context)
                  : AppColors.textSub(context),
              width: isSelected && !applyBlur ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildCardContent(context, applyBlur),
          ),
        ),

        /// 삭제 불가 blur
        if (applyBlur)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.background(context).withOpacity(0.6),
              ),
            ),
          ),
      ],
    );
  }

  // ------------------------------
  //   카드 내부 콘텐츠 구성
  // ------------------------------
  Widget _buildCardContent(BuildContext context, bool applyBlur) {
    return Row(
      children: [
        _buildAvatar(),

        const SizedBox(width: 16),

        _buildInfoText(context),

        const SizedBox(width: 16),

        _buildRightArea(context, applyBlur),
      ],
    );
  }

  // ------------------------------
  //   왼쪽 아바타 이미지 영역
  // ------------------------------
  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: calendarImage(imageUrl),
      ),
    );
  }

  // ------------------------------
  //   가운데 텍스트 정보
  // ------------------------------
  Widget _buildInfoText(BuildContext context) {
    final int id = calendarId ?? -1;

    // context.select를 사용하여 특정 ID의 데이터만 추출
    final String month = context.select<SharedCalendarViewModel, String>(
      (vm) => vm.nextScheduleDateMonth[id] ?? "",
    );
    final String day = context.select<SharedCalendarViewModel, String>(
      (vm) => vm.nextScheduleDateDay[id] ?? "",
    );
    final String scheduleTitle = context
        .select<SharedCalendarViewModel, String>(
          (vm) => vm.nextScheduleTitle[id] ?? "",
        );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // _buildMemberChip을 무조건 밀어내지 않게 자식의 크기에 맞추는 Flexible 사용
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMain(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildMemberChip(context),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  (month.isNotEmpty && day.isNotEmpty)
                      ? "다음 일정 : $month월 $day일 / ${[scheduleTitle]}"
                      : (scheduleTitle.isEmpty
                            ? "예정된 일정 없음"
                            : "일정 : $scheduleTitle"),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSub(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "$members 명",
        style: TextStyle(
          color: AppColors.textSub(context),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ------------------------------
  //   오른쪽 영역 (알림, 체크박스, 삭제 불가)
  // ------------------------------
  Widget _buildRightArea(BuildContext context, bool applyBlur) {
    final viewModel = context.watch<SharedCalendarViewModel>();
    if (!deleteMode) {
      /// 일반 모드 → 알림 표시
      // 새로운 채팅이 있을때만 표시
      if (viewModel.unreadCount[calendarId ?? 0] != 0) {
        return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.danger(context),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            "${viewModel.unreadCount[calendarId ?? 0] ?? 0}",
            style: TextStyle(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        return SizedBox(width: 42, height: 42);
      }
    }

    /// deleteMode === true
    if (isAdmin) {
      ///  관리자 → 삭제 불가
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.textSub(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          "삭제 불가",
          style: TextStyle(
            color: AppColors.textMain(context),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    /// 일반 사용자 → 체크박스
    return Checkbox(
      value: isSelected,
      activeColor: AppColors.danger(context),
      onChanged: (_) => onChangeSelected(),
    );
  }

  // ------------------------------
  //   이미지 렌더링 헬퍼 메서드
  // ------------------------------
  Widget calendarImage(String? url) {
    if (url == null || url.isEmpty) {
      return Image.asset("assets/images/calendar_logo.png", fit: BoxFit.cover);
    }
    if (url.startsWith("http")) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset("assets/images/calendar_logo.png"),
      );
    }
    return Image.asset(url, fit: BoxFit.cover);
  }
}
