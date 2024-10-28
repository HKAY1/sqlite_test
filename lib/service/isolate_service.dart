import 'dart:isolate';

class IsolateService {
  IsolateService._();

  static final IsolateService instance = IsolateService._();

  Future<T> runIsolateProvider<T>(T Function() task) async {
    return Isolate.run(task);
  }

  Future<T> spawnIsolateProvider<T>(T Function() task) async {
    final resultPort = ReceivePort();
    try {
      await Isolate.spawn(
        _taskToPerform,
        [resultPort.sendPort, task],
        errorsAreFatal: true,
        onExit: resultPort.sendPort,
        onError: resultPort.sendPort,
      );
    } on Object {
      // check if sending the entrypoint to the new isolate failed.
      // If it did, the result port won’t get any message, and needs to be closed
      resultPort.close();
    }
    final response = await resultPort.first;

    if (response == null) {
      throw 'No message';
    } else if (response is List) {
      // if the response is a list, this means an uncaught error occurred
      final errorAsString = response[0];
      final stackTraceAsString = response[1];

      throw 'Uncaught Error $errorAsString + $stackTraceAsString';
    } else {
      return response;
    }
  }
}

Future<void> _taskToPerform(List<dynamic> args) async {
  SendPort resultPort = args[0];
  Future task = args[1];

  final response = await task;

  Isolate.exit(resultPort, response);
}
