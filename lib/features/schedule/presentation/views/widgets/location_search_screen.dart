import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/data/models/location_search_result_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/location_search_view_model.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<LocationSearchResultModel?> showLocationDialog(BuildContext context) {
  return showDialog<LocationSearchResultModel>(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return ChangeNotifierProvider(
        create: (_) => LocationSearchViewModel(supabase),
        child: const _LocationSearchDialog(),
      );
    },
  );
}

class _LocationSearchDialog extends StatelessWidget {
  const _LocationSearchDialog();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LocationSearchViewModel>();

    return Dialog(
      backgroundColor: AppColors.surface(context),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          /// 제목
          const Text(
            "주소 검색",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          /// 검색창
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              onChanged: viewModel.onKeywordChanged,
              decoration: const InputDecoration(
                hintText: "주소를 입력하세요",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          if (viewModel.isLoading)
            Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: AppColors.primary(context),
                strokeWidth: 2,
              ),
            ),

          if (!viewModel.isLoading && viewModel.results.isNotEmpty)
            SizedBox(
              height: 300, // 다이얼로그 핵심
              child: ListView.builder(
                itemCount: viewModel.results.length,
                itemBuilder: (_, i) {
                  final item = viewModel.results[i];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.address),
                    onTap: () => context.pop(item),
                  );
                },
              ),
            ),

          if (!viewModel.isLoading && viewModel.results.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("검색 결과가 없습니다", style: TextStyle(color: Colors.grey)),
            ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
