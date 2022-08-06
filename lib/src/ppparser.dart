import 'dart:convert';
import 'dart:io';

final _regexIP = RegExp(r'(^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$)');
final _regexPort = RegExp(r'(^\d{1,6}$)');

/// Convert the input content into valid JSON.
Map<String, List<String>> _parseIPPortMap(String input) {
  final ipPortMap = <String, List<String>>{};
  final inputLines = input.split('\n');

  String? currentIP;
  for (final line in inputLines) {
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

/// Parse the input and return the output as JSON.
String parse(String input) {
  final ipPortMap = _parseIPPortMap(input);
  final ipPortJson = jsonEncode(ipPortMap);
  return ipPortJson;
}
