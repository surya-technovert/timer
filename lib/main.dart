import 'package:Reminder/domain/models/result/result.dart';
import 'package:Reminder/domain/use_cases/intialization_use_case.dart';
import 'package:Reminder/presentation/utils/helper_widgets_functions/error_helpers/error_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Reminder/presentation/screens/home.dart';

late Result<bool> res;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  res = await InitializeUseCase.instance.initializeAppRequirements();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ErrorHelper().handleResult(res, ref);
    return MaterialApp(
      title: 'Timely Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
