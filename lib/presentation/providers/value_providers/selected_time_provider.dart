import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<NavigationNotifier, TimeOfDay>
    selectedTimeProvider = StateNotifierProvider((ref) => NavigationNotifier());

class NavigationNotifier extends StateNotifier<TimeOfDay> {
  NavigationNotifier() : super(TimeOfDay.now());

  updateTime(TimeOfDay value) {
    state = value;
  }
}
