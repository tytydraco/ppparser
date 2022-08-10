import 'dart:io';

import 'package:args/args.dart';
import 'package:ppparser/src/ppparser.dart';
import 'package:stdlog/stdlog.dart' as std;

Future<void> main(List<String> arguments) async {
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

  final inputFile = File(inputFilePath);

  if (!inputFile.existsSync()) {
    std.error('Input file does not exist');
    exit(1);
  }

  final input = inputFile.readAsStringSync();
  final output = parse(input);
  File(outputFilePath).writeAsStringSync(output);
}
