import 'package:flutter_injections/src/exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InjectException', () {
    test('toString returns correct message', () {
      final exception = InjectException(message: 'Test message');
      expect(exception.toString(), 'InjectException: Test message');
    });
    test('toString returns correct message', () {
      final exception = NotDisposeException(message: 'Test message');
      expect(exception.toString(), 'NotDisposeException: Test message');
    });

    test('exception message is not null', () {
      final exception = NotDisposeException(message: 'Test message');
      expect(exception.message, isNotNull);
    });
  });
}
