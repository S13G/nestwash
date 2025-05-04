import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/clothes_model.dart';

final selectedOrderTabProvider = StateProvider<int>((ref) => 0);
final orderProgressProvider = StateProvider<double>((ref) => 0.0);
final currentStepProvider = StateProvider<int>((ref) => 0);
final completedStepsProvider = StateProvider<List<bool>>(
  (ref) => [false, false, false, false, false],
);

// Schedule pick up provider
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
final selectedTimeProvider = StateProvider<TimeOfDay?>((ref) => null);

// Schedule drop off provider
enum TimeRange { morning, afternoon, evening }

enum PreferredDay { anyDay, weekendsOnly, weekdaysOnly }

final selectedTimeRangeProvider = StateProvider<TimeRange?>((ref) => null);
final selectedPreferredDayProvider = StateProvider<PreferredDay?>(
  (ref) => null,
);

// Clothes provider
final selectedImagesProvider = StateProvider<List<File>>((ref) => []);
final isImageUploadingProvider = StateProvider<bool>((ref) => false);
final selectedItemsCountProvider = Provider<int>((ref) {
  final selectedItems = ref.watch(selectedItemsProvider);
  return selectedItems.values
      .map((item) => item.quantity)
      .fold(0, (sum, qty) => sum + qty);
});
final notesProvider = StateProvider<String>((ref) => '');

// Clothes Items Provider
final selectedItemsProvider = StateNotifierProvider<
  SelectedItemsNotifier,
  Map<String, ClothesItemSelectionModel>
>((ref) {
  return SelectedItemsNotifier();
});

class SelectedItemsNotifier
    extends StateNotifier<Map<String, ClothesItemSelectionModel>> {
  SelectedItemsNotifier()
    : super({
        'Outer wear': ClothesItemSelectionModel(),
        'Shirt': ClothesItemSelectionModel(),
        'Dress': ClothesItemSelectionModel(),
        'Others': ClothesItemSelectionModel(),
        'Bottom': ClothesItemSelectionModel(),
      });

  void updateQuantity(String itemName, int change) {
    final currentItem = state[itemName];
    if (currentItem != null) {
      final newQuantity = (currentItem.quantity + change).clamp(0, 99);
      state = {...state, itemName: currentItem.copyWith(quantity: newQuantity)};
    }
  }

  void updateGender(String itemName, String gender) {
    final currentItem = state[itemName];
    if (currentItem != null) {
      state = {...state, itemName: currentItem.copyWith(gender: gender)};
    }
  }
}

// Orders status
