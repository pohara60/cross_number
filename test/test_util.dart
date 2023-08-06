import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void handleTimestamp(String data, EventSink sink) {
  if (data.contains('elapsed')) {
    var newData =
        data.replaceAll(RegExp(r'elapsed [0-9:\.]*'), 'elapsed x:xx:xx.xxxxxx');
    sink.add(newData);
  } else {
    sink.add(data);
  }
}

dynamic appendToIterable(Iterable<dynamic> iter, dynamic item) sync* {
  for (var next in iter) yield next;
  yield item;
}

// Test the command line program
// output is the list of expected output lines
void test_command(String command, String output_file_name) {
  final path = 'bin/crossnumber.dart';

  test(command, () async {
    var timestampTransformer =
        StreamTransformer.fromHandlers(handleData: handleTimestamp);
    final process =
        await Process.start('dart', ['$path', ...command.split(' ')]);
    final lineStream = process.stdout
        .transform(Utf8Decoder())
        .transform(LineSplitter())
        .transform(timestampTransformer);

    var output_file = new File(output_file_name);
    List<String> output = output_file.readAsLinesSync();

    // Test output is expected
    expect(
      lineStream,
      emitsInOrder(appendToIterable(
        // Lines of output
        output.map((s) => s.replaceAll(
            RegExp(r'elapsed [0-9:\.]*'), 'elapsed x:xx:xx.xxxxxx')),
        // Assert that the stream emits a done event and nothing else
        emitsDone,
      )),
    );

    // Pipe the error output and exit code (if any)
    await process.stderr.pipe(stderr);
    var code = await process.exitCode;
    if (code != 0) {
      print('exit code: $code');
    }
  });
}
