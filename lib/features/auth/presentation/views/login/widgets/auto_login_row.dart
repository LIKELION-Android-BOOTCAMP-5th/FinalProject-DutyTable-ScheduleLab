import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class AutoLoginRow extends StatelessWidget {
  final bool isDarkMode;
  final bool isAutoLogin;
  final ValueChanged<bool?> onChanged;

  const AutoLoginRow({
    super.key,
    required this.isDarkMode,
    required this.isAutoLogin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isAutoLogin,
              activeColor: AppColors.primaryBlue,
              checkColor: AppColors.pureWhite,
              side: BorderSide(
                color: isDarkMode ? AppColors.dBorder : AppColors.lBorder,
              ),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '자동 로그인',
            style: TextStyle(color: AppColors.textMain(context)),
          ),
        ],
      ),
    );
  }
}
