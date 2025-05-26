class ConversionHistory {
  final String from;
  final String to;
  final double amount;
  final double convertedAmount;
  final DateTime date;

  ConversionHistory({
    required this.from,
    required this.to,
    required this.amount,
    required this.convertedAmount,
    required this.date,
  });
}
