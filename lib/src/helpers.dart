/// A class containing helper methods.
class Helpers {
  /// Sanitizes a string by removing any characters before the first occurrence of `<`
  /// and any occurrences of `>'` in the input string.
  ///
  /// Returns the sanitized string.
  static String sanitize(String value) =>
      value.split("<").last.replaceAll(">'", '');
}
