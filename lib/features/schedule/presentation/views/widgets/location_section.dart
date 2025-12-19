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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "일정 장소",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: addressController,
                readOnly: true,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "주소를 입력해주세요",
                  hintStyle: TextStyle(
                    color: AppColors.commonGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  suffixIcon: hasAddress
                      ? IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.grey),
                          onPressed: onClear,
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.card(context),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.cardBorder(context),
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
                  color: AppColors.commonBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.location_pin, color: AppColors.commonWhite),
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
