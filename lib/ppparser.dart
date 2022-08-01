import 'dart:convert';
import 'dart:io';

/// Parse a text file for IP-port combos and output the results to a JSON file.
class PPParser {
  /// Create a new [PPParser] given an [inputFilePath] and an [outputFilePath].
  PPParser({
    required this.inputFilePath,
    required this.outputFilePath,
  }) {
    if (!_inputFile.existsSync()) {
      stderr.writeln('Input file does not exist');
      exit(1);
    }
  }

  /// Input file to parse.
  final String inputFilePath;

  /// Output file to write the JSON to.
  final String outputFilePath;

  late final _inputFile = File(inputFilePath);
  final _regexIP = RegExp(r'(^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$)');
  final _regexPort = RegExp(r'(^\d{1,6}$)');

  /// Convert the input file into a valid JSON file.
  Future<Map<String, List<String>>> _parseIPPortMap() async {
    final ipPortMap = <String, List<String>>{};
    final inputFileLines = await _inputFile.readAsLines();

    String? currentIP;
    for (final line in inputFileLines) {
      final trimmedLine = line.trim();

      stdout.writeln('Reading: $trimmedLine');

      final ipMatch = _regexIP.firstMatch(trimmedLine)?.group(1);
      if (ipMatch != null) {
        stdout.writeln('Matched new IP: $ipMatch');
        currentIP = ipMatch;
        ipPortMap[currentIP] = [];
        continue;
      }

      final portMatch = _regexPort.firstMatch(trimmedLine)?.group(1);
      if (portMatch != null && currentIP != null) {
        stdout.writeln('Matched new port: $portMatch');
        ipPortMap[currentIP]!.add(portMatch);
        continue;
      } else if (portMatch != null && currentIP == null) {
        stderr.writeln('Matched port with no parent IP: $portMatch');
        exit(1);
      }

      if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
        stdout.writeln('Ignoring: $trimmedLine');
        continue;
      }

      stderr.writeln('Invalid syntax: $trimmedLine');
      exit(1);
    }

    stdout.writeln('Generated: ${ipPortMap.toString()}');

    return ipPortMap;
  }

  /// Parse and save the output.
  Future<void> parseAndSave() async {
    final ipPortMap = await _parseIPPortMap();
    final outputFile = File(outputFilePath);
    final ipPortJson = jsonEncode(ipPortMap);
    await outputFile.writeAsString(ipPortJson);
  }
}
