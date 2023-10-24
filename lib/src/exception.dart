/// A custom exception class for injection errors.
///
/// This class implements the built-in [Exception] class and adds a custom [message] property.
/// The [toString] method is overridden to return a formatted string with the exception message.
class InjectException implements Exception {
  final String message;
  InjectException({
    required this.message,
  });

  @override
  String toString() => "InjectException: $message";
}

class NotDisposeException implements Exception {
  final String message;
  NotDisposeException({
    required this.message,
  });

  @override
  String toString() => "NotDisposeException: $message";
}
