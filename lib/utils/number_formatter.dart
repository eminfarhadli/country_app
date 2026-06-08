class NumberFormatter {
  static String format(num number) {
    final isInt = number == number.toInt();
    final str = isInt ? number.toInt().toString() : number.toString();
    final parts = str.split('.');
    final intPart = parts[0];
    final regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    final formattedInt = intPart.replaceAllMapped(regExp, (Match match) => ',');
    if (parts.length > 1) {
      return '$formattedInt.${parts[1]}';
    }
    return formattedInt;
  }
}
