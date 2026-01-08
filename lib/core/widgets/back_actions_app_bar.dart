import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackActionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final VoidCallback? onAction;
  final List<Widget>? actions;

  const BackActionsAppBar({
    super.key,
    required this.title,
    this.onAction,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background(context),
        border: Border(
          bottom: BorderSide(color: AppColors.textSub(context), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.dBorder : AppColors.lBorder,
            blurRadius: 4.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: title,
        centerTitle: false,
        titleSpacing: 0,
        actions: actions,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        actionsPadding: EdgeInsets.only(right: 20.0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
