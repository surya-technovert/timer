import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:reminder_app/controllers/reoccurance_controller.dart';
import 'package:reminder_app/controllers/start_time_controller.dart';
import 'package:reminder_app/helpers/db_helper.dart';
import 'package:reminder_app/views/components/add_reminder.dart';
import '../../controllers/theme_controller.dart';
import '../../helpers/notification_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeController themeController = Get.put(ThemeController());

  StartTimeController startTimeController = Get.put(StartTimeController());
  ReoccuranceController reoccuranceController =
      Get.put(ReoccuranceController());

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/launcher_icon');
    var initializationSettingsIOs = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    NotificationHelper.flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminders"),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                themeController.changeTheme();
              },
              icon: Icon((themeController.isDark.value)
                  ? Icons.light_mode
                  : Icons.dark_mode),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addReminder(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: startTimeController.reminders
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.all(20),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            e.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(endIndent: 10, indent: 10),
                        const SizedBox(height: 5),
                        Text("Desc : ${e.description}"),
                        Row(
                          children: [
                            Text(
                                "Time : ${(e.startHour > 12) ? e.startHour - 12 : e.startHour} : ${e.startMinute}  ${(e.startHour > 12) ? "PM" : "AM"}",
                                style: Theme.of(context).textTheme.titleMedium),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text("Delete Reminder"),
                                    content: const Text(
                                      "Are you sure want to Delete?",
                                    ),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await NotificationHelper
                                              .notificationHelper
                                              .deleteReminder(e.id);
                                          await DBHelper.dbHelper
                                              .deleteReminder(id: e.id);
                                          Get.back();
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        Text("Recurrence : ${e.hour} ${e.minute}",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
