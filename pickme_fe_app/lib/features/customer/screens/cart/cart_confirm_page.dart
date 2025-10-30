import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/address_card.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/menu_list_card.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/voucher_card.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/payment_section.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/pickup_time_card.dart';
import 'package:intl/intl.dart';

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
    subtotal = widget.cartItems.fold(
      0.0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Appbar
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

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Address
          AddressCard(restaurant: widget.restaurant),

          const SizedBox(height: 12),

          // TimePicker
          PickupTimeCard(
            pickupTime: pickupTime,
            onAdjust: () => _selectTime(context),
          ),

          const SizedBox(height: 12),

          // List of food
          MenuListCard(
            restaurant: widget.restaurant,
            cartItems: widget.cartItems,
            subtotal: subtotal,
            total: widget.total,
          ),

          const SizedBox(height: 12),

          // Voucher
          VoucherCard(onAdd: () {}),

          const SizedBox(height: 100),
        ],
      ),
      bottomSheet: PaymentSection(
        payWithVisa: payWithVisa,
        onChanged: (value) => setState(() => payWithVisa = value),
        onConfirm: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Đặt đơn thành công!")));
        },
      ),
    );
  }

  // --- Picker time to select food ---
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
                  // Title
                  const Text(
                    "Thời gian lấy",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Hôm nay, ${DateFormat("d 'tháng' M").format(DateTime.now())}",
                    style: const TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 20),

                  // Picker time
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

                  // Confirm btn
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
