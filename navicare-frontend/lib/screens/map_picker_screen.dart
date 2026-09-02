// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import '../theme/app_theme.dart';

// class MapPickerScreen extends StatefulWidget {
//   const MapPickerScreen({super.key});

//   @override
//   State<MapPickerScreen> createState() => _MapPickerScreenState();
// }

// class _MapPickerScreenState extends State<MapPickerScreen> {
//   LatLng _selectedLatLng = const LatLng(13.0827, 80.2707); // Default coordinates (e.g., Chennai)

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         title: const Text('Select Location on Map', style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       body: Stack(
//         children: [
//           FlutterMap(
//             options: MapOptions(
//               initialCenter: _selectedLatLng,
//               initialZoom: 15.0,
//               onTap: (tapPosition, point) {
//                 setState(() {
//                   _selectedLatLng = point;
//                 });
//               },
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgentPackageName: 'com.example.accessease',
//                 tileProvider: NetworkTileProvider(),
//               ),
//               MarkerLayer(
//                 markers: [
//                   Marker(
//                     point: _selectedLatLng,
//                     width: 80,
//                     height: 80,
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: const Icon(
//                         Icons.location_pin,
//                         color: Colors.red,
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 24,
//             left: 16,
//             right: 16,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppTheme.primary,
//                 foregroundColor: AppTheme.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               onPressed: () {
//                 // Return formatted location string back to BookCaretakerScreen
//                 Navigator.pop(
//                   context,
//                   "Lat: ${_selectedLatLng.latitude.toStringAsFixed(4)}, Lng: ${_selectedLatLng.longitude.toStringAsFixed(4)}",
//                 );
//               },
//               child: const Text('Confirm Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


































import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:js' as js;



class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  // Default: Chennai (shown only until real location loads)
  LatLng _selectedLatLng = const LatLng(13.0827, 80.2707);
  bool _locationLoaded = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() {
    try {
      // Use browser Geolocation API via dart:js (Flutter Web)
      js.context.callMethod('eval', ['''
        navigator.geolocation.getCurrentPosition(
          function(pos) {
            window._navicare_lat = pos.coords.latitude;
            window._navicare_lng = pos.coords.longitude;
          },
          function(err) {
            window._navicare_lat = 13.0827;
            window._navicare_lng = 80.2707;
          },
          { enableHighAccuracy: true, timeout: 10000 }
        );
      ''']);

      // Poll until location is available
      Future.delayed(const Duration(seconds: 2), () => _checkLocation());
    } catch (e) {
      // Not on web or geolocation unavailable — keep default
    }
  }

  void _checkLocation() {
    try {
      final lat = js.context['_navicare_lat'];
      final lng = js.context['_navicare_lng'];
      if (lat != null && lng != null && mounted) {
        final latD = double.tryParse(lat.toString());
        final lngD = double.tryParse(lng.toString());
        if (latD != null && lngD != null) {
          setState(() {
            _selectedLatLng = LatLng(latD, lngD);
            _locationLoaded = true;
          });
          _mapController.move(_selectedLatLng, 15.0);
        }
      } else {
        // Try again after 1 more second
        Future.delayed(const Duration(seconds: 1), () => _checkLocation());
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        title: const Text('Select Location on Map',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLatLng,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() => _selectedLatLng = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.accessease',
                tileProvider: NetworkTileProvider(),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLatLng,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Loading indicator until real location loads
          if (!_locationLoaded)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 14, height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text('Getting your location...', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),

          // Confirm button
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  "Lat: ${_selectedLatLng.latitude.toStringAsFixed(4)}, "
                  "Lng: ${_selectedLatLng.longitude.toStringAsFixed(4)}",
                );
              },
              child: const Text('Confirm Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}