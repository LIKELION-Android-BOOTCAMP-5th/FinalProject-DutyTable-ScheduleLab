import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Theme(
      data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ExpansionTile(
          iconColor: AppColors.textMain(context),
          collapsedIconColor: AppColors.iconSub(context),
          title: Row(
            children: [
              Icon(
                Icons.nightlight_outlined,
                color: AppColors.textMain(context),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Text(
                  "테마",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain(context),
                  ),
                ),
              ),
            ],
          ),
          collapsedShape: RoundedRectangleBorder(
            side: BorderSide(
              color: isDarkMode ? AppColors.dBorder : AppColors.lBorder,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primary(context), width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          children: themeProvider.themeList.map((option) {
            return RadioListTile<String>(
              title: Text(
                option,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMain(context),
                ),
              ),
              value: option,
              groupValue: themeProvider.selectedOption,
              activeColor: AppColors.primaryBlue,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.updateTheme(value);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
