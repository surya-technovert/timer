import 'package:Reminder/domain/models/result/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<NavigationNotifier, Result> homeStateProvider =
    StateNotifierProvider((ref) => NavigationNotifier());

class NavigationNotifier extends StateNotifier<Result> {
  NavigationNotifier() : super(const Success(true));

  updateState(Result value) {
    state = value;
  }
}
