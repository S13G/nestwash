import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedOrderTabProvider = StateProvider<int>((ref) => 0);

final orderProgressProvider = StateProvider<double>((ref) => 0.25);
final currentStepProvider = StateProvider<int>((ref) => 0);
