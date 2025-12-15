import 'package:dutytable/features/schedule/data/models/address_search_result_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/address_search_view_model.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<AddressSearchResult?> showAddressSearchSheet(BuildContext context) {
  return showModalBottomSheet<AddressSearchResult>(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return ChangeNotifierProvider(
        create: (_) => AddressSearchViewModel(supabase),
        child: const _AddressSearchSheet(),
      );
    },
  );
}

class _AddressSearchSheet extends StatelessWidget {
  const _AddressSearchSheet();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddressSearchViewModel>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text("주소 검색", style: TextStyle(fontSize: 18)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              onChanged: vm.onKeywordChanged,
              decoration: const InputDecoration(
                hintText: "주소를 입력하세요",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          if (vm.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),

          if (!vm.isLoading)
            ListView.builder(
              shrinkWrap: true,
              itemCount: vm.results.length,
              itemBuilder: (_, i) {
                final item = vm.results[i];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.address),
                  onTap: () => Navigator.pop(context, item),
                );
              },
            ),
        ],
      ),
    );
  }
}
