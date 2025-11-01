import 'package:flutter/material.dart';

// Widget will receive this function
// Trigger when user click Update
typedef OnUpdateStatus = Future<void> Function(String status);

class UpdateOrderStatus extends StatefulWidget {
  final String? initialStatus;
  final OnUpdateStatus onUpdate;

  const UpdateOrderStatus({
    super.key,
    this.initialStatus,
    required this.onUpdate,
  });

  @override
  State<UpdateOrderStatus> createState() => _UpdateOrderStatusState();
}

class _UpdateOrderStatusState extends State<UpdateOrderStatus> {
  String? _selectedStatus;

  // Mapping for status
  final Map<String, String> statusLabels = {
    'PENDING': 'Chờ xác nhận',
    'CONFIRMED': 'Đã xác nhận',
    'PREPARING': 'Đang chuẩn bị',
    'READY': 'Sẵn sàng nhận món',
    'PICKED_UP': 'Đã lấy món',
    'COMPLETED': 'Hoàn thành',
  };

  @override
  void initState() {
    super.initState();
    // Find initialStatus in statusLabels object
    // if nout found set PENDING
    final matchedKey = statusLabels.entries
        .firstWhere(
          (entry) => entry.value == widget.initialStatus,
          orElse: () =>
              MapEntry(statusLabels.keys.first, statusLabels.values.first),
        )
        .key;

    _selectedStatus = matchedKey;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          child: Row(
            children: [
              // Text
              const Text(
                "Chọn trạng thái: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(width: 8),

              // Dropdown value
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  isExpanded: true,
                  items: statusLabels.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key, //value sent into database
                      child: Text(entry.value), //label in UI
                    );
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Button update
        ElevatedButton(
          onPressed: _selectedStatus == null
              ? null
              : () async {
                  await widget.onUpdate(_selectedStatus!);
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          child: const Text("Cập nhật"),
        ),
      ],
    );
  }
}
