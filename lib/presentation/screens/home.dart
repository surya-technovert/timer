import 'package:Reminder/core/models/reminder/isolate_helper/isolate_helper.dart';
import 'package:Reminder/domain/models/result/result.dart';
import 'package:Reminder/presentation/providers/state_providers/home_state_provider.dart';
import 'package:Reminder/presentation/utils/helper_widgets_functions/error_helpers/error_helper.dart';
import 'package:Reminder/presentation/widgets/error_dailogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/presentation/widgets/add_reminder.dart';
import 'package:Reminder/presentation/widgets/reminder_card.dart';
import 'package:Reminder/presentation/widgets/empty_data_widget.dart';
import 'package:Reminder/presentation/utils/extensions/context_extensions.dart';
import 'package:Reminder/presentation/providers/value_providers/data_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    IsolateHelper.port.listen((_) async {
      await ref.read(reminderDataProvider.notifier).updateReminderList();
      await ref
          .read(homeStateProvider.notifier)
          .updateState(((await ref.read(reminderDataProvider).reminderList)));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Result homeState = ref.watch(homeStateProvider);
    if (homeState is Success) {
      return WillPopScope(
        onWillPop: () async => false,
        child: FutureBuilder<Result<List<Reminder>>>(
            future: ref.watch(reminderDataProvider).reminderList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Reminder> data =
                    ErrorHelper().handleResult(snapshot.data!, ref);
                return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: context.inversePrimary,
                      title: const Text(
                        'Reminder',
                        style: TextStyle(fontFamily: 'Lugrasimo'),
                      ),
                    ),
                    body: (data.isNotEmpty)
                        ? buildListView(data)
                        : const EmptyDataWidget(),
                    floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddReminder()));
                        },
                        child: const Icon(Icons.add_alarm_sharp)));
              } else {
                return context.displayLoading;
              }
            }),
      );
    } else {
      if (homeState is Failure) {
        return ErrorDialog(homeState.exception, homeState.stackTrace);
      }
    }
    return ErrorDialog(
        Exception('Page State Seems Inavalid'), StackTrace.current);
  }

  ListView buildListView(List<Reminder> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return ReminderCard(
            data: data[index],
          );
        });
  }
}
