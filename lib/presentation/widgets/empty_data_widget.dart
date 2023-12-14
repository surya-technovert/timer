import 'package:flutter/cupertino.dart';
import 'package:Reminder/presentation/utils/extensions/context_extensions.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
          child: SizedBox(
              width: context.screenWidth,
              child: const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Column(children: [
                    Icon(
                      CupertinoIcons.square_stack_3d_up,
                    ),
                    Text('Add New Reminder to display one',
                        style: TextStyle(
                          fontFamily: 'Crimson',
                        )),
                  ])))),
    );
  }
}
