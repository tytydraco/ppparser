import 'dart:io';

import 'package:ppparser/ppparser.dart';
import 'package:test/test.dart';

void main() {
  test('Parse test file', () async {
    const inputFilePath = 'test/test_input.txt';
    const outputFilePath = 'test/test_output.json';

    final ppparser = PPParser(
      inputFilePath: inputFilePath,
      outputFilePath: outputFilePath,
    );

    await ppparser.parseAndSave();

    final outputFile = File(outputFilePath);
    final outputFileExists = await outputFile.exists();

    expect(outputFileExists, true);

    final outputFileContents = await outputFile.readAsString();
    expect(outputFileContents,
        '{"192.168.1.53":["66","1329","1142"],'
        '"192.144.2.177":["88","132","11"]}');
  });
}
