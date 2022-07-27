class InjectException implements Exception {
  final String message;
  InjectException({
    required this.message,
  });

  @override
  String toString() => "InjectException: $message";
}
