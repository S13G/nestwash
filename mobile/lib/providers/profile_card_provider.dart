import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchControllerNotifierProvider =
    StateNotifierProvider<SearchControllerNotifier, String>(
      (ref) => SearchControllerNotifier(),
    );

class SearchControllerNotifier extends StateNotifier<String> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  Timer? _debounce;

  SearchControllerNotifier() : super('') {
    controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final trimmedText = controller.text.trim();
    state = trimmedText;

    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 4), () {
      controller.clear();
      state = '';
      focusNode.unfocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.removeListener(_onSearchChanged);
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
