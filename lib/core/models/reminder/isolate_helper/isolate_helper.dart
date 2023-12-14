import 'dart:isolate';

class IsolateHelper {
  static String isolateName = 'isolate';
  static ReceivePort port = ReceivePort();
  static SendPort? uiSendPort;
}
