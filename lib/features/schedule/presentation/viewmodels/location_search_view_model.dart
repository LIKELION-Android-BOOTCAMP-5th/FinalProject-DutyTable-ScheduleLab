import 'dart:async';
import 'package:dutytable/features/schedule/domain/entities/location_search_result_entity.dart';
import 'package:dutytable/features/schedule/domain/usecases/search_address_use_case.dart';
import 'package:flutter/material.dart';

class LocationSearchViewModel extends ChangeNotifier {
  final SearchAddressUseCase _searchAddressUseCase;

  LocationSearchViewModel(this._searchAddressUseCase);

  Timer? _debounce;
  bool isLoading = false;
  List<LocationSearchResultEntity> results = [];

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

      results = await _searchAddressUseCase(keyword);

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
