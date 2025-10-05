class DiscountUsage {
  final String discountId;
  final String customerName;
  final String customerImage;
  final String orderId;
  final String serviceName;
  final DateTime usedAt;
  final double amountSaved;

  const DiscountUsage({
    required this.discountId,
    required this.customerName,
    required this.customerImage,
    required this.orderId,
    required this.serviceName,
    required this.usedAt,
    required this.amountSaved,
  });
}