import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

import 'package:pickme_fe_app/core/theme/app_colors.dart';

class AddressPickerField extends StatefulWidget {
  const AddressPickerField({super.key});

  @override
  State<AddressPickerField> createState() => _AddressPickerFieldState();
}

class _AddressPickerFieldState extends State<AddressPickerField> {
  List provinces = [];
  List districts = [];
  List wards = [];

  String? selectedProvinceName;
  String? selectedDistrictName;
  String? selectedWardName;
  String? selectedProvinceCode;
  String? selectedDistrictCode;
  final TextEditingController _streetController = TextEditingController();

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    getProvinces();
  }

  // Method get provinces
  Future<void> getProvinces() async {
    final res = await http.get(
      Uri.parse("http://provinces.open-api.vn/api/p/"),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(utf8.decode(res.bodyBytes));

      setState(() {
        provinces = data;
      });
    } else {
      throw Exception('Lấy tỉnh thành thất bại');
    }
  }

  // Method get districts
  Future<void> getDistricts(String provinceCode) async {
    final res = await http.get(
      Uri.parse("http://provinces.open-api.vn/api/p/$provinceCode?depth=2"),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(utf8.decode(res.bodyBytes));

      setState(() {
        districts = data['districts'] ?? [];
        wards = [];
        selectedDistrictName = null;
        selectedWardName = null;
      });
    } else {
      throw Exception('Lấy quận huyện thất bại');
    }
  }

  // Method get wards
  Future<void> getWards(String districtCode) async {
    final res = await http.get(
      Uri.parse("http://provinces.open-api.vn/api/d/$districtCode?depth=2"),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(utf8.decode(res.bodyBytes));

      setState(() {
        wards = data['wards'] ?? [];
        selectedWardName = null;
      });
    } else {
      throw Exception('Lấy phường thất bại');
    }
  }

  // Method get coordinate from address (latitude and longitude)
  Future<void> _getCoordinatesFromAddress(String address) async {
    try {
      // Use geocoding to get list of same address
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        setState(() {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy toạ độ với địa chỉ này'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lỗi khi lấy toạ độ')));
    }
  }

  // Method to concate address string
  void _onConfirm() async {
    if (selectedProvinceName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn Tỉnh/Thành phố')),
      );
      return;
    }

    if (selectedDistrictName == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng chọn Quận/Huyện')));
      return;
    }

    if (selectedWardName == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng chọn Phường/Xã')));
      return;
    }

    final address = [
      _streetController.text.trim(),
      selectedWardName,
      selectedDistrictName,
      selectedProvinceName,
    ].where((e) => e != null).join(', ');

    // Call method to get latitude and longitude
    await _getCoordinatesFromAddress(address);

    Navigator.pop(context, {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text(
          'Chọn địa chỉ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Provinces dropdown
            DropdownButtonFormField<String>(
              value: selectedProvinceName,
              hint: const Text("Chọn tỉnh/thành"),
              items: provinces.map<DropdownMenuItem<String>>((p) {
                return DropdownMenuItem(
                  value: p['name'],
                  child: Text(p['name']),
                  onTap: () {
                    selectedProvinceCode = p['code'].toString();
                  },
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvinceName = value;

                  // Call method getDistricts
                  getDistricts(selectedProvinceCode!);
                });
              },
            ),

            const SizedBox(height: 20),

            // District dropdown
            DropdownButtonFormField<String>(
              value: selectedDistrictName,
              hint: const Text("Chọn quận/huyện"),
              items: districts.map<DropdownMenuItem<String>>((d) {
                return DropdownMenuItem(
                  value: d['name'],
                  child: Text(d['name']),
                  onTap: () {
                    selectedDistrictCode = d['code'].toString();
                  },
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrictName = value;

                  // Call method getWards
                  getWards(selectedDistrictCode!);
                });
              },
            ),

            const SizedBox(height: 20),

            // Ward dropdown
            DropdownButtonFormField<String>(
              value: selectedWardName,
              hint: const Text("Chọn quận/huyện"),
              items: wards.map<DropdownMenuItem<String>>((w) {
                return DropdownMenuItem(
                  value: w['name'],
                  child: Text(w['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedWardName = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Address
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: "Tên đường / Số nhà",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Button conform address
            ElevatedButton(
              onPressed: _onConfirm,
              child: const Text("Xác nhận"),
            ),
          ],
        ),
      ),
    );
  }
}
