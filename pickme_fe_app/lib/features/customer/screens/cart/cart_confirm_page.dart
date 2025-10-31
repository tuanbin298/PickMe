import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/services/order/order_service.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/address_card.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/menu_list_card.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/voucher_card.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/pickup_time_card.dart';
import 'package:intl/intl.dart';

class CartConfirmPage extends StatefulWidget {
  final String token;
  final Restaurant restaurant;
  final List<CartItem> cartItems;
  final double total;
  final int cartId;

  const CartConfirmPage({
    super.key,
    required this.token,
    required this.restaurant,
    required this.cartItems,
    required this.total,
    required this.cartId,
  });

  @override
  State<CartConfirmPage> createState() => _CartConfirmPageState();
}

class _CartConfirmPageState extends State<CartConfirmPage> {
  DateTime _pickupTime = DateTime.now().add(const Duration(hours: 1));
  bool payWithVisa = true;
  late double subtotal;
  bool isLoading = false;

  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();

    subtotal = widget.cartItems.fold(
      0.0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );
  }

  // Method get current location
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check service enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng bật GPS để xem bản đồ")),
      );
      return null;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    // Get current location
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      // timeLimit: const Duration(seconds: 10),
    );

    return position;
  }

  // Method checkout to create order
  void _createOrder() async {
    final position = await _getCurrentLocation();

    final deliveryAddress = widget.restaurant.address;
    final pickupLatitude = widget.restaurant.latitude;
    final pickupLongitude = widget.restaurant.longitude;

    setState(() {
      isLoading = true;
    });

    final checkoutData = {
      "deliveryAddress": deliveryAddress,
      "pickupLatitude": pickupLatitude,
      "pickupLongitude": pickupLongitude,
      "currentLatitude": position?.latitude,
      "currentLongitude": position?.longitude,
      "preferredPickupTime": "${_pickupTime.toIso8601String()}Z",
      "specialInstructions": "string",
    };

    // print(checkoutData);

    try {
      final newOrder = await _orderService.createOrder(
        widget.token,
        widget.cartId,
        checkoutData,
      );

      if (!mounted) return;

      if (newOrder != null) {
        // Pop up create order success
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Đặt hàng thành công",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              content: const Text(
                "Đơn hàng của bạn đã được tạo.\nVui lòng tiến hành thanh toán để hoàn tất.",
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);

                    context.push(
                      "/order-confirm",
                      extra: {"token": widget.token, "id": newOrder.id},
                    );
                  },
                  child: const Text(
                    "Tiếp tục",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        NotificationService.showError(context, "Tạo đơn hàng thất bại!");
      }
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst("Exception: ", "");
      NotificationService.showError(context, message);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
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
            pickupTime: _pickupTime,
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

          const SizedBox(height: 80),
        ],
      ),

      // Button order
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _createOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "Đặt đơn",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // --- Picker time to select food ---
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(_pickupTime);

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
                          _pickupTime = DateTime(
                            _pickupTime.year,
                            _pickupTime.month,
                            _pickupTime.day,
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
