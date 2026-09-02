// NOTE: Add these to pubspec.yaml dependencies:
//   geolocator: ^12.0.0
//   permission_handler: ^11.3.1
//
// Add to AndroidManifest.xml (<manifest> level):
//   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
//   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';


// Uncomment when geolocator package is added:
import 'package:geolocator/geolocator.dart';

class HomeLocationMapScreen extends StatefulWidget {
  const HomeLocationMapScreen({super.key});

  @override
  State<HomeLocationMapScreen> createState() => _HomeLocationMapScreenState();
}

class _HomeLocationMapScreenState extends State<HomeLocationMapScreen> {
  // Home/destination location (Tambaram)
  static const LatLng _homeLocation = LatLng(12.9249, 80.1506);

  // Will be updated with actual GPS location
  LatLng _userLocation = const LatLng(12.9073, 80.2163); // fallback
  bool _locationLoaded = false;
  bool _locationError = false;
  String _locationName = 'Locating...';

  late MapController _mapController;
  bool _showRoute = false;
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  /// Gets the device's real GPS location.
  /// Uncomment the geolocator implementation once the package is added.
  Future<void> _getCurrentLocation() async {
    // ── REAL LOCATION (uncomment when geolocator is in pubspec) ────────────
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = true;
          _locationName = 'Location permission denied';
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = LatLng(pos.latitude, pos.longitude);
        _locationLoaded = true;
      });
      _reverseGeocode(pos.latitude, pos.longitude);
      _mapController.move(_userLocation, 13.0);
    } catch (e) {
      setState(() {
        _locationError = true;
        _locationName = 'Could not get location';
      });
    }
    // ─────────────────────────────────────────────────────────────────────────

    // DEMO: simulate location loading (remove this block when using geolocator)
    // await Future.delayed(const Duration(seconds: 1));
    // if (mounted) {
    //   setState(() {
    //     _locationLoaded = true;
    //     _locationName = 'Thalambur, Chennai';
    //   });
    // }
  }

  /// Reverse geocode coordinates to a human-readable name (Nominatim)
  Future<void> _reverseGeocode(double lat, double lng) async {
    try {
      final url = 'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json';
      final response = await http.get(Uri.parse(url),
        headers: {'User-Agent': 'NaviCareApp/1.0'}).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final address = json['address'] ?? {};
        final name = address['suburb'] ?? address['city'] ?? address['town'] ?? json['display_name'] ?? 'Your Location';
        if (mounted) setState(() => _locationName = name);
      }
    } catch (_) {}
  }

  Future<void> _fetchRoadRoute() async {
    setState(() => _loadingRoute = true);
    try {
      final url = 'https://router.project-osrm.org/route/v1/driving/'
          '${_userLocation.longitude},${_userLocation.latitude};'
          '${_homeLocation.longitude},${_homeLocation.latitude}'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final routes = json['routes'] as List;
        if (routes.isNotEmpty) {
          final coordinates = routes[0]['geometry']['coordinates'] as List;
          final points = coordinates.map((c) => LatLng(c[1], c[0])).toList().cast<LatLng>();
          setState(() {
            _routePoints = points;
            _showRoute = true;
          });
          final bounds = LatLngBounds.fromPoints(points);
          _mapController.fitBounds(bounds, options: const FitBoundsOptions(padding: EdgeInsets.all(80)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not load route: $e')));
      }
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Home - Tambaram', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            tooltip: 'Center on my location',
            onPressed: _locationLoaded
                ? () => _mapController.move(_userLocation, 14.0)
                : null,
          ),
        ],
      ),
      body: Column(
        children: [
          // Map
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(center: _homeLocation, zoom: 13.0),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.accessease',
                    ),
                    if (_showRoute && _routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(points: _routePoints, strokeWidth: 4.0, color: AppTheme.primary),
                        ],
                      ),
                    MarkerLayer(markers: [
                      // Home marker
                      Marker(
                        point: _homeLocation,
                        width: 64, height: 64,
                        child: Column(
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 8)]),
                              child: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
                              child: const Text('Home', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      // User marker
                      if (_locationLoaded)
                        Marker(
                          point: _userLocation,
                          width: 64, height: 64,
                          child: Column(
                            children: [
                              Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(color: Colors.blue[600], shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 8)]),
                                child: const Icon(Icons.person_pin_circle_rounded, color: Colors.white, size: 18),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(color: Colors.blue[600], borderRadius: BorderRadius.circular(8)),
                                child: const Text('You', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                    ]),
                  ],
                ),
                // Location loading overlay
                if (!_locationLoaded)
                  Positioned(
                    top: 12, left: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary)),
                          const SizedBox(width: 10),
                          Text('Getting your location...', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom info panel
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your location card
                const Text('Your Current Location',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: _locationError ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _locationError ? Icons.location_off_rounded : Icons.my_location_rounded,
                          color: _locationError ? Colors.red : Colors.blue[600], size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_locationName,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                          Text(
                            _locationLoaded
                              ? '${_userLocation.latitude.toStringAsFixed(4)}, ${_userLocation.longitude.toStringAsFixed(4)}'
                              : 'Fetching GPS coordinates...',
                            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (_locationLoaded)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 7, color: Color(0xFF22C55E)),
                              SizedBox(width: 4),
                              Text('Live', style: TextStyle(fontSize: 11, color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Route info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.route_rounded, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text('Route Information',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E))),
                      ),
                      _routeItem(Icons.straighten_rounded, '~8.0 km'),
                      const SizedBox(width: 12),
                      _routeItem(Icons.timer_rounded, '~1 hour'),
                      const SizedBox(width: 12),
                      _routeItem(Icons.directions_bus_rounded, 'Auto/Bus'),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Get Directions button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _loadingRoute ? null : _fetchRoadRoute,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    icon: _loadingRoute
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : const Icon(Icons.navigation_rounded, size: 20),
                    label: Text(
                      _loadingRoute ? 'Loading Route...' : 'Get Directions',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w600)),
      ],
    );
  }
}
