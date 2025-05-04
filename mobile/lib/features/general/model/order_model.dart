class Order {
  final String id;
  final DateTime orderDate;
  final DateTime deliveryDate;
  String status;
  final List<OrderItem> items;
  final double total;
  final String address;
  final String? deliveryDelayReason;

  Order({
    required this.id,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.items,
    required this.total,
    required this.address,
    this.deliveryDelayReason,
  });

  // Sample order for preview
  static Order sampleOrder() {
    return Order(
      id: "ORD-2023-9876",
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
      deliveryDelayReason: "Delayed delivery",
      status: "Ready for delivery",
      items: [
        OrderItem(name: "Outer wear", quantity: 2, price: 3.0, category: "Men"),
        OrderItem(name: "Shirt", quantity: 3, price: 3.0, category: "Men"),
        OrderItem(name: "Underwear", quantity: 1, price: 3.0, category: "Men"),
      ],
      total: 18.0,
      address: "123 Main Street, Apt 4B, New York, NY 10001",
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String category;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
  });
}
