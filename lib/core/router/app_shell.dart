import 'package:dutytable/features/calendar/presentation/viewmodels/personal_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import '../configs/app_colors.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // 마지막으로 뒤로가기 버튼을 누른 시간 기록
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);
    final location = GoRouterState.of(context).uri.toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false, // 시스템 뒤로가기 기본 동작을 막음
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        // 1. 현재 위치가 메인 탭(/shared)이 아닌 경우 메인으로 이동
        if (location != '/shared') {
          context.go('/shared');
          return;
        }

        // 2. 이미 메인 탭인 경우 "한 번 더 눌러 종료" 로직 실행
        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          // 2초 이내에 다시 누르지 않았을 때
          _lastPressedAt = now;

          // 토스트 메시지 형태의 스낵바 노출
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '한 번 더 누르면 종료됩니다.',
                style: TextStyle(color: AppColors.textMain(context)),
              ),
              backgroundColor: AppColors.surface(context),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isDark ? AppColors.dBorder : AppColors.lBorder,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            ),
          );
        } else {
          // 2초 이내에 다시 누른 경우 앱 종료
          SystemNavigator.pop();
        }
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Scaffold(
          body: widget.child,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.dBorder : AppColors.lBorder,
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    if (location.startsWith('/shared')) {
                      context.read<SharedCalendarViewModel>().fetchCalendars();
                    }
                    context.go('/shared');
                    break;
                  case 1:
                    if (location.startsWith('/personal')) {
                      context.read<PersonalCalendarViewModel>().fetchCalendar();
                    }
                    context.go('/personal');
                    break;
                  case 2:
                    context.go('/profile');
                    break;
                }
              },
              backgroundColor: AppColors.background(context),
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              selectedItemColor: AppColors.primary(context),
              unselectedItemColor: AppColors.textSub(context),
              items: [
                BottomNavigationBarItem(
                  icon: _buildSharedCalendarIcon(
                    context,
                    active: false,
                    icon: _buildSharedCalendarInnerIcon(context, active: false),
                  ),
                  activeIcon: _buildSharedCalendarIcon(
                    context,
                    active: true,
                    icon: _buildSharedCalendarInnerIcon(context, active: true),
                  ),
                  label: "공유 캘린더",
                ),
                BottomNavigationBarItem(
                  icon: _buildSharedCalendarIcon(
                    context,
                    active: false,
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 22,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  activeIcon: _buildSharedCalendarIcon(
                    context,
                    active: true,
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 22,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  label: "내 캘린더",
                ),
                BottomNavigationBarItem(
                  icon: _buildSharedCalendarIcon(
                    context,
                    active: false,
                    icon: const Icon(
                      Icons.person_outline,
                      size: 22,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  activeIcon: _buildSharedCalendarIcon(
                    context,
                    active: true,
                    icon: const Icon(
                      Icons.person,
                      size: 22,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  label: "프로필",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/shared')) return 0;
    if (location.startsWith('/personal')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }
}

// 아이콘 빌더 함수들 (기존과 동일)
Widget _buildSharedCalendarInnerIcon(
  BuildContext context, {
  required bool active,
}) {
  final Color bgColor = active
      ? AppColors.primary(context)
      : AppColors.textSub(context);
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
        const Icon(Icons.calendar_month, size: 22, color: AppColors.pureWhite),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: AppColors.pureWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.group, size: 10, color: bgColor),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSharedCalendarIcon(
  BuildContext context, {
  required bool active,
  required Widget icon,
}) {
  final Color bgColor = active
      ? AppColors.primary(context)
      : AppColors.textSub(context);
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
