import '../../models/order/order.dart';

class OrderService {
  // Simulated fetch order history
  Future<List<OrderModel>> getOrderHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      OrderModel(
        title: "Bún bò cô Ba",
        address: "Nguyễn Xiển, Long Thạnh Mỹ",
        price: 40000,
        quantity: 1,
        status: "Hoàn thành",
        date: "Thứ 3, 02/04/2025",
        image:
            "https://images.unsplash.com/photo-1550547660-d9450f859349?w=800&q=80",
      ),
      OrderModel(
        title: "Phở bò tái chín",
        address: "Lê Văn Việt, Quận 9",
        price: 45000,
        quantity: 1,
        status: "Hoàn thành",
        date: "Thứ 5, 04/04/2025",
        image:
            "https://images.unsplash.com/photo-1550547660-d9450f859349?w=800&q=80",
      ),
    ];
  }
}
