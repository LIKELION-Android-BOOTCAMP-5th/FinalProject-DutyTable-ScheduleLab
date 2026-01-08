import 'dart:async';
import 'package:dutytable/features/schedule/data/models/location_search_result_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationSearchViewModel extends ChangeNotifier {
  final SupabaseClient supabase;

  LocationSearchViewModel(this.supabase);

  Timer? _debounce;
  bool isLoading = false;
  List<LocationSearchResultModel> results = [];

  void onKeywordChanged(String keyword) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (keyword.length < 2) {
        results = [];
        notifyListeners();
        return;
      }

      isLoading = true;
      notifyListeners();

      final res = await supabase.functions.invoke(
        'hyper-endpoint',
        body: {'type': 'search', 'query': keyword},
      );

      results = (res.data as List)
          .map((e) => LocationSearchResultModel.fromJson(e))
          .toList();

      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
