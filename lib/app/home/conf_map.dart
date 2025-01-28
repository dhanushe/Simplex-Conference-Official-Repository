import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../api/app_info.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _center;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getLatLng(AppInfo.conference.specificLoc);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getLatLng(String address) async {
    const String apiKey = 'AIzaSyDGtvdkDK3mHBoAIdYeoMwfLU9GU-XF3pM';
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final location = data['results'][0]['geometry']['location'];
      setState(() {
        _center = LatLng(location['lat'], location['lng']);
        _markers.add(
          Marker(
            markerId: const MarkerId('location'),
            position: _center!,
            infoWindow: InfoWindow(
              title: 'Conference Location',
              snippet: address,
            ),
          ),
        );
      });
    } else {
      throw Exception('Failed to load location data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _center == null
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center!,
              zoom: 14.0,
            ),
            markers: _markers,
          );
  }
}
