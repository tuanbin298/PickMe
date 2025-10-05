import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';

class LocationPickerField extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final ValueChanged<Map<String, double>> onLocationSelected;

  const LocationPickerField({
    super.key,
    this.latitude,
    this.longitude,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;

  // Assign value from parent widget to variable when init screen
  @override
  void initState() {
    super.initState();
    _latitude = widget.latitude;
    _longitude = widget.longitude;
  }

  // Method to get current location of user
  Future<void> _getLocation() async {
    setState(() => _isLoading = true);

    try {
      // Check service enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng bật dịch vụ định vị trên thiết bị.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Check permission
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();

      // Get location logic
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter:
            100, //Only update location when device move at least 100m
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      // Set location into variable
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isLoading = false;
      });

      // Call to parent widget, to refesh UI
      widget.onLocationSelected({
        "latitude": _latitude!,
        "longitude": _longitude!,
      });

      // Msg success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã lấy vị trí thành công: '
            '${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);

      // Msg fail
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lấy vị trí: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Method return label of location field
  String _buildLocationLabel() {
    if (_isLoading) {
      return "Đang lấy vị trí...";
    } else if (_latitude != null) {
      return "Cập nhật lại vị trí quán";
    } else {
      return "Lấy vị trí cửa hàng hiện tại";
    }
  }

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

            const SizedBox(height: 16),

            // UI location
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                // Call method _getLocation
                onPressed: _isLoading ? null : _getLocation,
                icon: const Icon(Icons.my_location),
                label: Text(_buildLocationLabel()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
