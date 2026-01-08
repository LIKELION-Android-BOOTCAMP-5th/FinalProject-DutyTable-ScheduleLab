import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/views/widgets/naver_map_section.dart';
import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final String? address;
  final String? latitude;
  final String? longitude;
  final TextEditingController addressController;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const LocationSection({
    super.key,
    this.address,
    this.latitude,
    this.longitude,
    required this.addressController,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasAddress = address != null && address!.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 장소",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: addressController,
                readOnly: true,
                maxLines: 1,
                style: TextStyle(color: AppColors.textMain(context)),
                decoration: InputDecoration(
                  hintText: "주소를 입력해주세요",
                  hintStyle: TextStyle(
                    color: AppColors.textSub(context),
                    fontWeight: FontWeight.w600,
                  ),
                  suffixIcon: hasAddress
                      ? IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: AppColors.iconSub(context),
                          ),
                          onPressed: onClear,
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surface(context),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.dBorder : AppColors.lBorder,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primary(context),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: onSearch,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: AppColors.primary(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.location_pin, color: AppColors.pureWhite),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (hasAddress && latitude != null && longitude != null)
          RepaintBoundary(
            child: NaverMapSection(latitude: latitude!, longitude: longitude!),
          ),
      ],
    );
  }
}
