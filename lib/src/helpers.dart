class Helpers {
  Helpers();
  static String sanitize(String value) =>
      value.split("<").last.replaceAll(">'", '');
}
