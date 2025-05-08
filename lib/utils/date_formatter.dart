class DateFormatter {
  static String formatDate(dynamic dateInput) {
    if (dateInput is DateTime) {
      return '${dateInput.year}/${dateInput.month}/${dateInput.day} ${dateInput.hour}:${dateInput.minute.toString().padLeft(2, '0')}';
    } else if (dateInput is String) {
      try {
        final date = DateTime.parse(dateInput);
        return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        return dateInput;
      }
    }

    return dateInput?.toString() ?? '不明';
  }
}
