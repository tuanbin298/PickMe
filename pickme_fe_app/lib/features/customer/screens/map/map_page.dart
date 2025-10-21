import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  LatLng? _destination;

  final RestaurantService _restaurantService = RestaurantService();
  List<Restaurant> _restaurants = [];

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
      timeLimit: const Duration(seconds: 10),
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Move map to current location
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
          : FlutterMap(
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
              ),
              children: [
                // Layer of map
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                                Icons.location_on,
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

      // Button to view current mark
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location, size: 30, color: Colors.white),
        onPressed: _getCurrentLocation,
      ),
    );
  }
}
