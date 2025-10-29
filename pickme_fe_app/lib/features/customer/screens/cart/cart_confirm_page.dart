import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';

class CartConfirmPage extends StatefulWidget {
  final String token;
  final Restaurant restaurant;
  final List<CartItem> cartItems;
  final double total;

  const CartConfirmPage({
    super.key,
    required this.token,
    required this.restaurant,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CartConfirmPage> createState() => _CartConfirmPageState();
}

class _CartConfirmPageState extends State<CartConfirmPage> {
  DateTime pickupTime = DateTime.now().add(const Duration(hours: 1));
  bool payWithVisa = true;

  late double subtotal;

  @override
  void initState() {
    super.initState();
    subtotal = _calculateSubtotal();
  }

  double _calculateSubtotal() {
    return widget.cartItems.fold(
      0.0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,##0", "vi_VN");
    return "${formatter.format(amount)} đ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Xác nhận đơn hàng",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Địa chỉ quán (TỪ widget.restaurant) ---
            _buildCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Địa chỉ quán",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.restaurant.address, // ĐÚNG 100%
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Thời gian lấy ---
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Thời gian lấy",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _selectTime(context),
                        child: const Text("Điều chỉnh"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('h:mm a').format(pickupTime),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Hiện tại khung giờ ${DateFormat('h:mm a').format(pickupTime)} đã gần giờ lấy, hãy liên hệ trước khi đến quán để người bán chuẩn bị món nhé.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Danh sách món (TỪ cartItems + tên quán) ---
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÊN QUÁN
                  Text(
                    widget.restaurant.name, // ĐÚNG 100%
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ĐỊA CHỈ QUÁN (dưới tên quán)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.restaurant.address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Danh sách món
                  if (widget.cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "Giỏ hàng trống",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...widget.cartItems.asMap().entries.map((entry) {
                      final item = entry.value;
                      final index = entry.key;

                      return Column(
                        children: [
                          if (index > 0)
                            Divider(
                              height: 24,
                              thickness: 1,
                              color: Colors.grey.shade200,
                            ),
                          _buildMenuItem(
                            item.menuItemName,
                            item.unitPrice,
                            item.menuItemImageUrl,
                            quantity: item.quantity,
                            specialInstructions: item.specialInstructions,
                            addOns: item.addOns,
                          ),
                        ],
                      );
                    }).toList(),

                  const SizedBox(height: 16),
                  Divider(
                    height: 24,
                    thickness: 1,
                    color: Colors.grey.shade200,
                  ),

                  // Tổng tạm tính
                  _buildAmountRow("Tổng tạm tính", subtotal),
                  const SizedBox(height: 8),
                  _buildAmountRow("Voucher", 0, color: Colors.black54),
                  Divider(
                    height: 24,
                    thickness: 1,
                    color: Colors.grey.shade200,
                  ),

                  // Tổng cộng
                  _buildAmountRow(
                    "Tổng cộng",
                    widget.total,
                    isTotal: true,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Mã giảm giá ---
            _buildCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mã giảm giá",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  TextButton(onPressed: () {}, child: const Text("Thêm")),
                ],
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),

      // --- Thanh toán + Đặt đơn ---
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildPaymentOption(
                  "VISA",
                  "https://i.imgur.com/8nGk3Wv.png",
                  payWithVisa,
                ),
                const SizedBox(width: 10),
                _buildPaymentOption(
                  "Tiền mặt",
                  "https://i.imgur.com/QxqvN0x.png",
                  !payWithVisa,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đặt đơn thành công!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Đặt đơn",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Card ---
  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  // --- Widget Món ăn ---
  Widget _buildMenuItem(
    String name,
    double price,
    String imageUrl, {
    required int quantity,
    String? specialInstructions,
    List<AddOn>? addOns,
  }) {
    return StatefulBuilder(
      builder: (context, setStateItem) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      if (specialInstructions != null &&
                          specialInstructions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Ghi chú: $specialInstructions",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                      if (addOns != null && addOns.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            children: addOns.map((a) {
                              return Chip(
                                label: Text(
                                  a.price > 0
                                      ? "${a.name} (+${formatCurrency(a.price)})"
                                      : a.name,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                backgroundColor: Colors.orange.shade50,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildQtyButton(
                            icon: Icons.remove,
                            onTap: quantity > 1
                                ? () => setStateItem(() => quantity--)
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "$quantity",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _buildQtyButton(
                            icon: Icons.add,
                            color: Colors.orange,
                            onTap: () => setStateItem(() => quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  formatCurrency(price * quantity),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // --- Nút + / - ---
  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback? onTap,
    Color color = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: onTap != null
              ? color.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? color : Colors.grey.shade400,
        ),
      ),
    );
  }

  // --- Dòng tiền ---
  Widget _buildAmountRow(
    String label,
    double amount, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          formatCurrency(amount),
          style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // --- Phương thức thanh toán ---
  Widget _buildPaymentOption(String label, String iconUrl, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => payWithVisa = (label == "VISA")),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(iconUrl, width: 28, height: 28),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.orange : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Chọn thời gian ---
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(pickupTime);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Thời gian lấy",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Hôm nay, ${DateFormat('d tháng M').format(DateTime.now())}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
                      initialTimerDuration: Duration(
                        hours: selectedTime.hour,
                        minutes: (selectedTime.minute ~/ 5) * 5,
                      ),
                      minuteInterval: 5,
                      onTimerDurationChanged: (duration) {
                        setModalState(() {
                          selectedTime = TimeOfDay(
                            hour: duration.inHours % 24,
                            minute: duration.inMinutes % 60,
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          pickupTime = DateTime(
                            pickupTime.year,
                            pickupTime.month,
                            pickupTime.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Xác nhận",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
