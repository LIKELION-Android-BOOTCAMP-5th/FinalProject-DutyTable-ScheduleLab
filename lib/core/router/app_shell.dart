import 'package:dutytable/features/calendar/presentation/viewmodels/personal_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import '../configs/app_colors.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);
    final location = GoRouterState.of(context).uri.toString(); // 현재 위치 가져오기

    return Theme(
      // 리플 효과 삭제
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        body: child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.commonGrey, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  // 이미 공유 캘린더 탭이거나, 공유 캘린더의 상세 페이지에 있는 경우
                  if (location.startsWith('/shared')) {
                    // 리스트 화면 새로고침
                    context.read<SharedCalendarViewModel>().fetchCalendars();
                  }
                  context.go('/shared');
                  break;
                case 1:
                  if (location.startsWith('/personal')) {
                    // 개인 캘린더 화면 새로고침
                    context.read<PersonalCalendarViewModel>().fetchCalendar();
                  }
                  context.go('/personal');
                  break;
                case 2:
                  context.go('/profile');
                  break;
              }
            },
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            type: BottomNavigationBarType.fixed,
            // 클릭된 바텀 네비게이션 탭 라벨
            showSelectedLabels: true,
            // 클릭되지 않은 바텀 네비게이션 탭 라벨
            showUnselectedLabels: true,
            // 클릭된 바텀 네비게이션 라벨 텍스트 스타일
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            // 클릭되지 않은 바텀 네비게이션 라벨 텍스트 스타일
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            // 클릭된 바텀 네비게이션 탭 색
            selectedItemColor: AppColors.commonBlue,
            // 클릭되지 않은 바텀 네비게이션 탭 색
            unselectedItemColor: AppColors.commonGrey,
            items: [
              // 공유 캘린더 - active: false(클릭되지 않은) / true(클릭된)
              BottomNavigationBarItem(
                icon: _buildSharedCalendarIcon(
                  active: false,
                  icon: _buildSharedCalendarInnerIcon(active: false),
                ),
                activeIcon: _buildSharedCalendarIcon(
                  active: true,
                  icon: _buildSharedCalendarInnerIcon(active: true),
                ),
                label: "공유 캘린더",
              ),

              // 내 캘린더 - active: false(클릭되지 않은) / true(클릭된)
              BottomNavigationBarItem(
                icon: _buildSharedCalendarIcon(
                  active: false,
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 22,
                    color: AppColors.commonWhite,
                  ),
                ),
                activeIcon: _buildSharedCalendarIcon(
                  active: true,
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 22,
                    color: AppColors.commonWhite,
                  ),
                ),
                label: "내 캘린더",
              ),

              // 프로필 - active: false(클릭되지 않은) / true(클릭된)
              BottomNavigationBarItem(
                icon: _buildSharedCalendarIcon(
                  active: false,
                  icon: Icon(
                    Icons.person_outline,
                    size: 22,
                    color: AppColors.commonWhite,
                  ),
                ),
                activeIcon: _buildSharedCalendarIcon(
                  active: true,
                  icon: Icon(
                    Icons.person,
                    size: 22,
                    color: AppColors.commonWhite,
                  ),
                ),
                label: "프로필",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 현재 위치 index 값
  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/shared')) {
      return 0;
    } else if (location.startsWith('/personal')) {
      return 1;
    } else if (location.startsWith('/profile')) {
      return 2;
    }
    return 0;
  }
}

// 공유 캘린더 아이콘 - 원(캘린더 + 유저 그룹 아이콘 합침)
Widget _buildSharedCalendarInnerIcon({required bool active}) {
  final Color bgColor = active
      ? AppColors.commonBlue
      : AppColors.commonGreyShade400;

  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.calendar_month, size: 22, color: AppColors.commonWhite),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.commonWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.group, size: 10, color: bgColor),
          ),
        ),
      ],
    ),
  );
}

// 내 캘린더 및 프로필 아이콘 - 원(캘린더 또는 유저 아이콘)
Widget _buildSharedCalendarIcon({required bool active, required Widget icon}) {
  final Color bgColor = active
      ? AppColors.commonBlue
      : AppColors.commonGreyShade400;

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: icon,
    ),
  );
}
