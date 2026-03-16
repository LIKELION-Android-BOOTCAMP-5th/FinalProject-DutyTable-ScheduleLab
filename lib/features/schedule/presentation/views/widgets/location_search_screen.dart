import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/di/injection.dart';
import 'package:dutytable/features/schedule/domain/entities/location_search_result_entity.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/location_search_view_model.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<LocationSearchResultEntity?> showLocationDialog(
  BuildContext context, {
  String? initialKeyword,
}) {
  return showDialog<LocationSearchResultEntity>(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return ChangeNotifierProvider(
        create: (_) => getIt<LocationSearchViewModel>(),
        child: _LocationSearchDialog(initialKeyword: initialKeyword),
      );
    },
  );
}

class _LocationSearchDialog extends StatefulWidget {
  final String? initialKeyword;
  const _LocationSearchDialog({this.initialKeyword});

  @override
  State<_LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<_LocationSearchDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialKeyword ?? '');
    if (widget.initialKeyword != null && widget.initialKeyword!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LocationSearchViewModel>().searchImmediately(widget.initialKeyword!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              controller: _controller,
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
