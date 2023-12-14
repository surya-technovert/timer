import 'package:Reminder/domain/models/result/result.dart';
import 'package:Reminder/presentation/providers/state_providers/home_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorHelper {
  dynamic handleResult(Result result, WidgetRef ref) {
    if (result is Failure) {
      ref.read(homeStateProvider.notifier).updateState(result);
    } else {
      if (result is Success) {
        return result.value;
      }
    }
  }
}
