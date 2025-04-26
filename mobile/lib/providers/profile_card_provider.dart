import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

final searchFocusNodeProvider = Provider<FocusNode>((ref) {
  final focusNode = FocusNode();
  ref.onDispose(() => focusNode.dispose());
  return focusNode;
});

final searchControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final controller = TextEditingController();
  Timer? debounceTimer;

  void listener() {
    ref.read(searchTextProvider.notifier).state = controller.text.trim();

    // Reset and start the timer
    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(seconds: 4), () {
      // Clear text and remove focus after 3 seconds of inactivity
      controller.clear();
      ref.read(searchTextProvider.notifier).state = '';
      ref.read(searchFocusNodeProvider).unfocus();
    });
  }

  // Add the listener to the controller
  controller.addListener(listener);

  // Clean up on dispose
  ref.onDispose(() {
    controller.removeListener(listener);
    debounceTimer?.cancel();
    controller.dispose();
  });

  return controller;
});
