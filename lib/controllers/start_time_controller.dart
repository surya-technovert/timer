import 'package:get/get.dart';
import 'package:reminder_app/modals/reminder.dart';
import 'package:reminder_app/modals/reminder_db.dart';

class StartTimeController extends GetxController {
  RxInt year = 0.obs;
  RxInt month = 0.obs;
  RxInt day = 0.obs;
  RxInt hour = 0.obs;
  RxInt minute = 0.obs;

  RxList<ReminderDB> reminders = <ReminderDB>[].obs;

  setDateTime({required int hourVal, required int minuteVal}) {
    hour.value = hourVal;
    minute.value = minuteVal;
  }

  clearDateTime() {
    hour.value = 0;
    minute.value = 0;
  }
}
