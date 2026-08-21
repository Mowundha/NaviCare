import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';

class HomeLocationMapScreen extends StatefulWidget {
  const HomeLocationMapScreen({super.key});

  @override
  State<HomeLocationMapScreen> createState() => _HomeLocationMapScreenState();
}

class _HomeLocationMapScreenState extends State<HomeLocationMapScreen> {
  // Tambaram location coordinates
  static const LatLng tambaram = LatLng(12.9249, 80.1506);
  
  // User's current location - Thalambur
  static const LatLng userLocation = LatLng(12.9073, 80.2163);

  late MapController mapController;
  bool _showRoute = false;
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  // Fetch actual road route from OSRM
  Future<void> _fetchRoadRoute() async {
    setState(() {
      _loadingRoute = true;
    });

    try {
      // OSRM (Open Street Map Routing Service) API endpoint
      final String url =
          'https://router.project-osrm.org/route/v1/driving/${userLocation.longitude},${userLocation.latitude};${tambaram.longitude},${tambaram.latitude}?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.Response('', 500),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final routes = json['routes'] as List;

        if (routes.isNotEmpty) {
          final route = routes[0];
          final geometry = route['geometry'];
          final coordinates = geometry['coordinates'] as List;

          final points = coordinates
              .map((coord) => LatLng(coord[1], coord[0]))
              .toList()
              .cast<LatLng>();

          setState(() {
            _routePoints = points;
            _showRoute = true;
          });

          // Fit map bounds
          final bounds = LatLngBounds.fromPoints(points);
          mapController.fitBounds(
            bounds,
            options: const FitBoundsOptions(
              padding: EdgeInsets.all(100),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load route: $e')),
        );
      }
    } finally {
      setState(() {
        _loadingRoute = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        title: const Text('My Home - Tambaram', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation),
            onPressed: () {
              mapController.move(tambaram, 16.0);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map Layer
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: tambaram,
              initialZoom: 15.0,
              minZoom: 5.0,
              maxZoom: 19.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.accessease',
                tileProvider: NetworkTileProvider(),
              ),
              // Draw road route polyline
              PolylineLayer(
                polylines: _showRoute && _routePoints.isNotEmpty
                    ? [
                        // Shadow/background line for depth
                        Polyline(
                          points: _routePoints,
                          color: Colors.black.withValues(alpha: 0.15),
                          strokeWidth: 7.0,
                          isDotted: false,
                        ),
                        // Main route line with gradient effect
                        Polyline(
                          points: _routePoints,
                          color: AppTheme.primary,
                          strokeWidth: 5.0,
                          isDotted: false,
                          gradientColors: [
                            Colors.blue.shade600,
                            AppTheme.primary,
                            Colors.blue.shade400,
                          ],
                        ),
                      ]
                    : [],
              ),
              // Markers for user location and home
              MarkerLayer(
                markers: [
                  // Home marker
                  Marker(
                    point: tambaram,
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                  // User current location marker
                  Marker(
                    point: userLocation,
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Location Information Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      'Your Home Location',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location Detail
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.neutral100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tambaram',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Chennai, Tamil Nadu, India',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Route Information
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.neutral100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.directions,
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Route Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Distance',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '~8.0 km',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated Time',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '~1 hour',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transport',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Auto/Bus',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _loadingRoute ? null : _fetchRoadRoute,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: _loadingRoute
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(AppTheme.white),
                                    ),
                                  )
                                : const Icon(Icons.navigation),
                            label: Text(_loadingRoute ? 'Loading...' : 'Get Directions'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
