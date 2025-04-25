import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

final searchFocusNodeProvider = Provider<FocusNode>((ref) => FocusNode());
