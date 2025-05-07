import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final emailControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
final emailProvider = StateProvider<String>((ref) => '');

final fullNameControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final loadingProvider = StateProvider<bool>((ref) => false);

final passwordVisibilityProvider = StateProvider<bool>((ref) => false);
