import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool deleteMode;
  final bool isAdmin;
  final bool isSelected;
  final int members;
  final VoidCallback onChangeSelected;

  const CalendarCard({
    super.key,
    required this.title,
    this.imageUrl,
    required this.deleteMode,
    required this.isAdmin,
    required this.isSelected,
    required this.members,
    required this.onChangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final applyBlur = deleteMode && isAdmin;
    print(applyBlur);
    print(deleteMode);
    print(isAdmin);

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
                color: AppColors.cardBlur(context),
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
        color: const Color(0xFF3A7BFF),
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
    return Expanded(
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

              _buildMemberChip(context),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "다음 일정: 12월 5일",
            style: TextStyle(fontSize: 12, color: AppColors.commonGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.chip(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "$members 명",
        style: TextStyle(
          color: AppColors.chipText(context),
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
    if (!deleteMode) {
      /// 일반 모드 → 알림 표시
      return Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Text(
          "99+",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }

    /// deleteMode === true
    if (isAdmin) {
      ///  관리자 → 삭제 불가
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.chip(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          "삭제 불가",
          style: TextStyle(
            color: AppColors.chipText(context),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    /// 일반 사용자 → 체크박스
    return Checkbox(
      value: isSelected,
      activeColor: AppColors.commonRed,
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
