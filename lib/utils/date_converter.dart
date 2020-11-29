DateTime dateConverter(String dateString) {
  return DateTime.utc(
    0000,
    00,
    00,
    DateTime.parse(dateString).hour,
    DateTime.parse(dateString).minute,
    00,
  );
}
