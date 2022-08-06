import 'package:ppparser/src/ppparser.dart';
import 'package:test/test.dart';

const exampleInput = '''
# Example one
192.168.1.53
66
1329
1142

# Example two
192.144.2.177
88
132
11''';

void main() {
  test('Parse test content', () async {
    expect(
      parse(exampleInput),
      '{"192.168.1.53":["66","1329","1142"],'
      '"192.144.2.177":["88","132","11"]}',
    );
  });
}
