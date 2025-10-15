import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:pickme_fe_app/core/theme/app_colors.dart';

class LocationPickerField extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const LocationPickerField({super.key, this.latitude, this.longitude});

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _latitude = widget.latitude;
    _longitude = widget.longitude;
  }

  //didUpdateWidget: is a lifecycle method, call every time parent widgets rebuild and pass new value
  // @override
  // void didUpdateWidget(covariant LocationPickerField oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // Khi parent truyền toạ độ mới -> cập nhật lại
  //   if (widget.latitude != oldWidget.latitude ||
  //       widget.longitude != oldWidget.longitude) {
  //     setState(() {
  //       _latitude = widget.latitude;
  //       _longitude = widget.longitude;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.redAccent),

                SizedBox(width: 8),

                Text(
                  "Vị trí cửa hàng",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Subtitle latitude and longitude
            // toStringAsFixed(5): keep 5 number after comma
            Text(
              _latitude != null && _longitude != null
                  ? "Tọa độ: ${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}"
                  : "Chưa xác định vị trí quán",
              style: TextStyle(
                fontSize: 14,
                color: _latitude != null && _longitude != null
                    ? Colors.black87
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
