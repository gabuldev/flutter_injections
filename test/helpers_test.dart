import 'package:flutter_injections/src/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Helpers', () {
    test(
        'sanitize() removes characters before first < and all occurrences of >\'',
        () {
      expect(Helpers.sanitize("<test>'"), equals('test'));
    });
  });
}
