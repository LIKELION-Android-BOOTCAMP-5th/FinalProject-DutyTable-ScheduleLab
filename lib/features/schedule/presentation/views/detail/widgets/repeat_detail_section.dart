import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 일정 상세 - 반복
class RepeatDetailSection extends StatelessWidget {
  const RepeatDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();
    if (!viewModel.isRepeat) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 1. 반복 주기 설정 (추가 화면과 동일한 레이아웃)
          Row(
            children: [
              Expanded(flex: 1, child: _sectionLabel("반복 주기", context)),
              Expanded(
                flex: 1,
                child: _readOnlyContainer(
                  context,
                  viewModel.repeatNum.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _readOnlyContainer(
                  context,
                  _getRepeatOptionLabel(viewModel.repeatOption),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// 2. 반복 종료 정보 (상세 화면은 결과만 표시)
          _sectionLabel("반복 종료", context),
          const SizedBox(height: 8),
          _readOnlyContainer(
            context,
            "총 ${viewModel.repeatCount}회 반복 설정됨",
            isFullWidth: true,
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 16),

          /// 3. 예외 옵션 (주말/공휴일 - _OptionCard 스타일 통일)
          Row(
            children: [
              Expanded(
                child: _optionCardRead(
                  context: context,
                  label: "주말 제외",
                  isCheck: viewModel.weekendException,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _optionCardRead(
                  context: context,
                  label: "공휴일 제외",
                  isCheck: viewModel.holidayException,
                ),
              ),
            ],
          ),

          /// 4. 특정 제외 날짜 (ListView.builder 스타일 통일)
          if (viewModel.excludedDates.isNotEmpty) ...[
            const SizedBox(height: 16),
            _sectionLabel("특정 제외 날짜", context),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.excludedDates.length,
              itemBuilder: (context, index) {
                return _excludedDateReadTile(
                  context: context,
                  dateStr: viewModel.excludedDates[index],
                  isDark: isDark,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // --- 추가 화면 스타일과 일치시킨 컴포넌트들 ---

  Widget _sectionLabel(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.textMain(context),
      ),
    );
  }

  /// 추가 화면의 TextFormField/Dropdown 디자인과 일치하는 읽기 전용 박스
  Widget _readOnlyContainer(
    BuildContext context,
    String text, {
    bool isFullWidth = false,
    IconData? icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.dBorder : AppColors.lBorder,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: isFullWidth
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: AppColors.textMain(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (icon != null)
            Icon(icon, size: 18, color: AppColors.primary(context)),
        ],
      ),
    );
  }

  /// 추가 화면의 _OptionCard 디자인 통일
  Widget _optionCardRead({
    required BuildContext context,
    required String label,
    required bool isCheck,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Opacity(
      opacity: isCheck ? 1.0 : 0.5, // 체크 안 된 옵션은 흐릿하게 표시
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.dBorder : AppColors.lBorder,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              activeColor: AppColors.primary(context),
              checkColor: AppColors.pureWhite,
              value: isCheck,
              onChanged: null, // 클릭 방지
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textSub(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 추가 화면의 _ExcludedDateTile 디자인 통일
  Widget _excludedDateReadTile({
    required BuildContext context,
    required String dateStr,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.dBorder : AppColors.lBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateStr,
            style: TextStyle(
              color: AppColors.textMain(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(
            Icons.lock_clock,
            size: 18,
            color: Colors.grey[400],
          ), // 삭제 버튼 대신 읽기전용 아이콘
        ],
      ),
    );
  }

  String _getRepeatOptionLabel(String option) {
    switch (option) {
      case 'daily':
        return '일 마다';
      case 'weekly':
        return '주 마다';
      case 'monthly':
        return '개월 마다';
      case 'yearly':
        return '년 마다';
      default:
        return option;
    }
  }
}
