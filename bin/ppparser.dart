import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:ppparser/ppparser.dart';

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.FINER;
  Logger.root.onRecord.listen((event) {
    final message = '[${event.level.name}] ${event.message}';
    stdout.writeln(message);
  });

  final parser = ArgParser();
  parser
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Shows the usage',
      negatable: false,
      callback: (enabled) {
        if (enabled) {
          stdout.writeln(parser.usage);
          exit(0);
        }
      },
    )
    ..addOption(
      'input',
      abbr: 'i',
      help: 'The input file to use',
      mandatory: true,
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: 'The output file to use',
      defaultsTo: 'out.json',
    );

  final options = parser.parse(arguments);
  final inputFilePath = options['input'] as String;
  final outputFilePath = options['output'] as String;

  final ppparser = PPParser(
    inputFilePath: inputFilePath,
    outputFilePath: outputFilePath,
  );

  await ppparser.parseAndSave();
}
