enum TransactionFilterType { all, thisMonth, last3Months, last6Months, thisYear }

enum TransactionStatus { completed, refunded, pending }

class TransactionModel {
  final String id;
  final String serviceName;
  final String providerName;
  final String providerImage;
  final double amount;
  final DateTime date;
  final TransactionStatus status;
  final List<String> items;

  TransactionModel({
    required this.id,
    required this.serviceName,
    required this.providerName,
    required this.providerImage,
    required this.amount,
    required this.date,
    required this.status,
    required this.items,
  });
}
