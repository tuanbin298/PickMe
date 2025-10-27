import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/services/restaurant/restaurant_service.dart';
import 'package:pickme_fe_app/features/customer/widgets/map/restaurant_marker_dialog.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Map controller
  final MapController _mapController = MapController();

  // Variable for location
  LatLng? _currentLocation;
  LatLng? _destination;

  // Polylines
  List<LatLng> _routePoints = [];

  double? _distance;
  double? _duration;

  final RestaurantService _restaurantService = RestaurantService();
  List<Restaurant> _restaurants = [];

  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getRestaurantLocation();
  }

  // Method get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check service enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng bật GPS để xem bản đồ")),
      );
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    // Get current location
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      // timeLimit: const Duration(seconds: 10),
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  // Move screen to current location
  void _moveScreenToCurrentLocation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_currentLocation!, 18.5);
    });
  }

  // Method get all restaurant
  Future<void> _getRestaurantLocation() async {
    try {
      final restaurantData = await _restaurantService.getPublicRestaurants();
      setState(() {
        _restaurants = restaurantData;
      });
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh sách quán ăn: $err')),
      );
    }
  }

  // Method get coordinates for given location using OpenStreetMap Nominatim API
  Future<void> _fetchCoordinatesPoints(String location) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1",
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'PickMeApp/1.0 (contact@pickme.vn)',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        final latitude = double.parse(data[0]['lat']);
        final longitude = double.parse(data[0]['lon']);

        setState(() {
          _destination = LatLng(latitude, longitude);
        });

        await fetchRoute();
      } else {
        NotificationService.showSuccess(context, "Không tìm kiếm thấy địa chỉ");
      }
    } else {
      NotificationService.showError(context, "Lỗi khi tìm kiếm địa chỉ");
    }
  }

  // Method to fetch the route between the current location and the destination using OSRM API
  Future<void> fetchRoute() async {
    if (_currentLocation == null || _destination == null) return;

    final url = Uri.parse(
      "http://router.project-osrm.org/route/v1/driving/"
      '${_currentLocation!.longitude},${_currentLocation!.latitude};'
      '${_destination!.longitude},${_destination!.latitude}?overview=full&geometries=polyline',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'PickMeApp/1.0 (contact@pickme.vn)',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final polyline = data['routes'][0]['geometry'];
        final distance = (data['routes'][0]['distance'] as num).toDouble();
        final duration = (data['routes'][0]['duration'] as num).toDouble();

        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decodePoints = polylinePoints.decodePolyline(
          polyline,
        );

        setState(() {
          _routePoints = decodePoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          _distance = distance;
          _duration = duration;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(_destination!, 13);
        });
      } else {
        NotificationService.showSuccess(context, "Không tìm thấy tuyến đường");
      }
    } else {
      NotificationService.showError(context, "Lỗi khi lấy dữ liệu tuyến đường");
    }
  }

  // Method update location when user moving each 10m
  void _trackingLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((
      Position position,
    ) {
      final newLocation = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        _currentLocation = newLocation;
      });

      // Move camera to current location
      _mapController.move(newLocation, _mapController.camera.zoom);

      // Update location when user moving
      if (_destination != null) {
        final distance = Distance();
        final double meters = distance.as(
          LengthUnit.Meter,
          newLocation,
          _destination!,
        );

        // Check destination
        if (meters <= 2) {
          //If near the destination
          _clearDestination();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Bạn đã đến điểm đến!")));
        } else {
          // Else continue tracking location
          fetchRoute();
        }
      }
    });
  }

  // Method to clear destination
  void _clearDestination() {
    setState(() {
      _destination = null;
      _routePoints.clear();
      _distance = null;
      _duration = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã huỷ điểm đến")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text(
          'Bản đồ',
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

      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  // Setting map
                  mapController: _mapController,
                  options: MapOptions(
                    // User current location
                    initialCenter: LatLng(
                      _currentLocation!.latitude,
                      _currentLocation!.longitude,
                    ),
                    initialZoom: 14.5,
                    minZoom: 0,
                    maxZoom: 100,
                    // Update polylines
                    onMapReady: _trackingLocationStream,
                  ),
                  children: [
                    // Layer of map
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),

                    // User mark
                    CurrentLocationLayer(
                      style: LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: Icon(Icons.location_pin, color: Colors.red),
                        ),
                        markerSize: Size(45, 45),
                        markerDirection: MarkerDirection.heading,
                      ),
                    ),

                    if (_destination != null)
                      // Destination mark
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _destination!,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                    if (_currentLocation != null &&
                        _destination != null &&
                        _routePoints.isNotEmpty)
                      // Polylines
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 5,
                            color: Colors.red,
                          ),
                        ],
                      ),

                    if (_restaurants.isNotEmpty)
                      // Restaurant mark
                      MarkerLayer(
                        // Loop in _restaurants to render
                        markers: _restaurants.map((restaurant) {
                          return Marker(
                            // Location of restaurant
                            point: LatLng(
                              restaurant.latitude ?? 0,
                              restaurant.longitude ?? 0,
                            ),
                            width: 80,
                            height: 80,
                            child: GestureDetector(
                              // Click into restaurant mark
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => RestaurantMarkerDialog(
                                    restaurant: restaurant,
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  // Icon
                                  const Icon(
                                    Icons.restaurant,
                                    color: Colors.orange,
                                    size: 50,
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    // Restaurant name
                                    child: Text(
                                      restaurant.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),

                //Search destination
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Input
                        Expanded(
                          child: TextField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Nhập điểm đến của bạn",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                          ),
                        ),

                        // IconButton
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            final location = _locationController.text.trim();

                            if (location.isNotEmpty) {
                              _fetchCoordinatesPoints(location);
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ),

                // Travel information
                if (_distance != null && _duration != null)
                  if (_distance != null && _duration != null)
                    Positioned(
                      top: 70,
                      left: 16,
                      right: 16,
                      // Container distance
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8),

                                  // Icons distance
                                  child: const Icon(
                                    Icons.route,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    const Text(
                                      "Khoảng cách",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    // Text
                                    Text(
                                      "${(_distance! / 1000).toStringAsFixed(2)} km",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Container duration
                            Container(
                              width: 1,
                              height: 35,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  //  Icons
                                  child: const Icon(
                                    Icons.timer,
                                    color: Colors.orange,
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title duration
                                    const Text(
                                      "Thời gian",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    // Text duration
                                    Text(
                                      "${(_duration! / 60).toStringAsFixed(1)} phút",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                // Cancel destination button
                if (_destination != null)
                  Positioned(
                    bottom: 90,
                    right: 16,
                    child: FloatingActionButton.extended(
                      heroTag: "cancelDestination",
                      backgroundColor: Colors.redAccent,
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        "Huỷ điểm đến",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: _clearDestination,
                    ),
                  ),
              ],
            ),

      // Button to view current mark
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location, size: 30, color: Colors.white),
        onPressed: _moveScreenToCurrentLocation,
      ),
    );
  }
}
