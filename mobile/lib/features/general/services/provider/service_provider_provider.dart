import 'package:hooks_riverpod/hooks_riverpod.dart';

final availabilityStatusProvider = StateProvider.autoDispose<bool>((ref) => true); // true = active, false = busy

