import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCalendarTabView extends StatefulWidget {
  final int tabLength;
  final List<String> tabNameList;
  final List<Widget> tabViewWidgetList;

  const CustomCalendarTabView({
    super.key,
    required this.tabLength,
    required this.tabNameList,
    required this.tabViewWidgetList,
  }) : assert(
         tabLength == tabNameList.length &&
             tabLength == tabViewWidgetList.length,
       );

  @override
  State<CustomCalendarTabView> createState() => _CustomCalendarTabViewState();
}

class _CustomCalendarTabViewState extends State<CustomCalendarTabView> {
  final List<Color> _tabColors = const [
    AppColors.primaryChatTextLight,
    AppColors.primaryListTextLight,
    AppColors.chatMyMessageLight,
  ];

  int _selectedIndex = 0;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 탭 버튼 영역
        _buildCustomTabBar(),

        // 탭 뷰 영역
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: widget.tabViewWidgetList,
          ),
        ),
      ],
    );
  }

  // 탭 버튼
  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.tabLength, (index) {
            final isSelected = _selectedIndex == index;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () => _onTabSelected(index),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _tabColors[index]
                          // TODO: 민석님
                          : AppColors.card(context),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      widget.tabNameList[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.commonWhite
                            : AppColors.commonGrey,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
