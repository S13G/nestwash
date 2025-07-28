import 'package:nestcare/shared/util/general_utils.dart';

class Order {
  final String id;
  final DateTime orderDate;
  final DateTime deliveryDate;
  OrderStatus status;
  final List<OrderItem> items;
  final double totalPrice;
  final String address;
  final String? deliveryDelayReason;
  final String serviceType;

  Order({
    required this.id,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.items,
    required this.totalPrice,
    required this.address,
    required this.serviceType,
    this.deliveryDelayReason,
  });

  // Sample order for preview
  static List<Order> sampleOrder() {
    return [
      Order(
        id: "ORD-2023-9876",
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        deliveryDelayReason: "Delayed delivery",
        status: OrderStatus.readyForDelivery,
        items: [
          OrderItem(name: "Outer wear", quantity: 2, price: 3.0, category: "Men"),
          OrderItem(name: "Shirt", quantity: 3, price: 3.0, category: "Men"),
          OrderItem(name: "Underwear", quantity: 1, price: 3.0, category: "Men"),
        ],
        totalPrice: 18.0,
        address: "123 Main Street, Apt 4B, New York, NY 10001",
        serviceType: 'Wash & Fold',
      ),
      Order(
        id: "ORD-2023-9877",
        orderDate: DateTime.now().subtract(const Duration(days: 4)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        deliveryDelayReason: "Delayed delivery",
        status: OrderStatus.pending,
        items: [
          OrderItem(name: "Outer wear", quantity: 2, price: 3.0, category: "Men"),
          OrderItem(name: "Shirt", quantity: 3, price: 3.0, category: "Men"),
          OrderItem(name: "Underwear", quantity: 1, price: 3.0, category: "Men"),
        ],
        totalPrice: 18.0,
        address: "123 Main Street, Apt 4B, New York, NY 10001",
        serviceType: 'Dry clean',
      ),
      Order(
        id: "ORD-2023-9897",
        orderDate: DateTime.now().subtract(const Duration(days: 4)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        deliveryDelayReason: "Delayed delivery",
        status: OrderStatus.completed,
        items: [
          OrderItem(name: "Outer wear", quantity: 2, price: 3.0, category: "Men"),
          OrderItem(name: "Shirt", quantity: 3, price: 3.0, category: "Men"),
          OrderItem(name: "Underwear", quantity: 1, price: 3.0, category: "Men"),
        ],
        totalPrice: 18.0,
        address: "123 Main Street, Apt 4B, New York, NY 10001",
        serviceType: 'Dry clean',
      ),
      Order(
        id: "ORD-2023-9898",
        orderDate: DateTime.now().subtract(const Duration(days: 4)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        deliveryDelayReason: "Delayed delivery",
        status: OrderStatus.active,
        items: [
          OrderItem(name: "Outer wear", quantity: 2, price: 3.0, category: "Men"),
          OrderItem(name: "Shirt", quantity: 3, price: 3.0, category: "Men"),
          OrderItem(name: "Underwear", quantity: 1, price: 3.0, category: "Men"),
        ],
        totalPrice: 18.0,
        address: "123 Main Street, Apt 4B, New York, NY 10001",
        serviceType: 'Dry clean',
      ),
      Order(
        id: "ORD-2023-9897",
        orderDate: DateTime.now().subtract(const Duration(days: 4)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        deliveryDelayReason: "Delayed delivery",
        status: OrderStatus.cancelled,
        items: [
          OrderItem(name: "Outer wear", quantity: 2, price: 3.0, category: "Men"),
          OrderItem(name: "Shirt", quantity: 3, price: 3.0, category: "Men"),
          OrderItem(name: "Underwear", quantity: 1, price: 3.0, category: "Men"),
        ],
        totalPrice: 18.0,
        address: "123 Main Street, Apt 4B, New York, NY 10001",
        serviceType: 'Dry clean',
      ),
      Order(
        id: "ORD-2023-9897",
        orderDate: DateTime.now().subtract(const Duration(days: 4)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        deliveryDelayReason: "Delayed delivery",
        status: OrderStatus.readyForPickup,
        items: [
          OrderItem(name: "Outer wear", quantity: 2, price: 3.0, category: "Men"),
          OrderItem(name: "Shirt", quantity: 3, price: 3.0, category: "Men"),
          OrderItem(name: "Underwear", quantity: 1, price: 3.0, category: "Men"),
        ],
        totalPrice: 18.0,
        address: "123 Main Street, Apt 4B, New York, NY 10001",
        serviceType: 'Dry clean',
      ),
    ];
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String category;

  OrderItem({required this.name, required this.quantity, required this.price, required this.category});
}
