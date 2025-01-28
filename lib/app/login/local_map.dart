import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../../api/objects/conference_data.dart';

class GoogleMapsPage extends StatefulWidget {
  final List<ConferenceData> conferences;

  const GoogleMapsPage({super.key, required this.conferences});

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController mapController;
  final LatLng _initialPosition =
      const LatLng(47.6062, -122.3321); // Washington coordinates
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadConferenceMarkers();
  }

  Future<void> _loadConferenceMarkers() async {
    Map<String, LatLng> conferences = {
      'Tech Summit': const LatLng(37.7749, -122.4194), // San Francisco, CA
      'Health Expo': const LatLng(34.0522, -118.2437), // Los Angeles, CA
      'EduCon': const LatLng(40.7128, -74.0060), // New York, NY
      'AI Conference': const LatLng(42.3601, -71.0589), // Boston, MA
      'Cyber Security Summit':
          const LatLng(38.9072, -77.0369), // Washington, D.C.
      'Green Energy Symposium': const LatLng(47.6062, -122.3321), // Seattle, WA
      'Finance Forum': const LatLng(41.8781, -87.6298), // Chicago, IL
      'Marketing Meetup': const LatLng(29.7604, -95.3698), // Houston, TX
      'Gaming Expo': const LatLng(36.1699, -115.1398), // Las Vegas, NV
      'Mobile World Congress':
          const LatLng(32.7157, -117.1611), // San Diego, CA
      'Developer Week': const LatLng(39.7392, -104.9903), // Denver, CO
      'StartUp Grind': const LatLng(25.7617, -80.1918), // Miami, FL
      'Business Expo': const LatLng(33.7490, -84.3880), // Atlanta, GA
      'Data Science Summit': const LatLng(45.5152, -122.6784), // Portland, OR
      'Design Conference': const LatLng(30.2672, -97.7431), // Austin, TX
      'Blockchain Symposium': const LatLng(39.1031, -84.5120), // Cincinnati, OH
      'LegalTech Conference':
          const LatLng(44.9778, -93.2650), // Minneapolis, MN
      'BioTech Summit': const LatLng(40.4406, -79.9959), // Pittsburgh, PA
      'Smart Cities Expo': const LatLng(33.4484, -112.0740), // Phoenix, AZ
      'Robotics Conference': const LatLng(29.4241, -98.4936), // San Antonio, TX
      'VR/AR Summit': const LatLng(32.7767, -96.7970), // Dallas, TX
      'E-commerce Expo': const LatLng(39.7684, -86.1581), // Indianapolis, IN
      'Digital Transformation Forum':
          const LatLng(37.3382, -121.8863), // San Jose, CA
      'Cloud Expo': const LatLng(30.3322, -81.6557), // Jacksonville, FL
      'IoT Conference': const LatLng(39.9612, -82.9988), // Columbus, OH
      'Wearable Tech Summit':
          const LatLng(29.9511, -90.0715), // New Orleans, LA
      'AgriTech Conference': const LatLng(38.2527, -85.7585), // Louisville, KY
      'Nanotech Expo': const LatLng(35.2271, -80.8431), // Charlotte, NC
      'Quantum Computing Summit':
          const LatLng(36.1627, -86.7816), // Nashville, TN
      'SpaceTech Symposium':
          const LatLng(37.7749, -122.4194), // San Francisco, CA
      'MedTech Forum': const LatLng(34.0522, -118.2437), // Los Angeles, CA
      'Insurance Tech Conference':
          const LatLng(40.7128, -74.0060), // New York, NY
      'Construction Tech Expo': const LatLng(42.3601, -71.0589), // Boston, MA
      'Automotive Tech Summit':
          const LatLng(38.9072, -77.0369), // Washington, D.C.
      'Sports Tech Conference': const LatLng(47.6062, -122.3321), // Seattle, WA
      'Food Tech Expo': const LatLng(41.8781, -87.6298), // Chicago, IL
      'Music Tech Symposium': const LatLng(29.7604, -95.3698), // Houston, TX
      'Tourism Tech Forum': const LatLng(36.1699, -115.1398), // Las Vegas, NV
      'Education Innovation Summit':
          const LatLng(32.7157, -117.1611), // San Diego, CA
      'Fashion Tech Conference': const LatLng(39.7392, -104.9903), // Denver, CO
      'Retail Tech Expo': const LatLng(25.7617, -80.1918), // Miami, FL
      'Hospitality Tech Summit': const LatLng(33.7490, -84.3880), // Atlanta, GA
      'Transport Tech Conference':
          const LatLng(45.5152, -122.6784), // Portland, OR
      'Real Estate Tech Forum': const LatLng(30.2672, -97.7431), // Austin, TX
      'HR Tech Conference': const LatLng(39.1031, -84.5120), // Cincinnati, OH
      'Sustainability Tech Expo':
          const LatLng(44.9778, -93.2650), // Minneapolis, MN
      'Climate Change Summit':
          const LatLng(40.4406, -79.9959), // Pittsburgh, PA
      'Logistics Tech Conference':
          const LatLng(33.4484, -112.0740), // Phoenix, AZ
      'Entertainment Tech Symposium':
          const LatLng(29.4241, -98.4936), // San Antonio, TX
      'Future of Work Forum': const LatLng(32.7767, -96.7970), // Dallas, TX
    };
    for (var conference in widget.conferences) {
      List<Location> locations =
          await locationFromAddress(conference.specificLoc);
      if (locations.isNotEmpty) {
        LatLng position =
            LatLng(locations.first.latitude, locations.first.longitude);
        _markers.add(Marker(
          markerId: MarkerId(conference.name),
          position: position,
          infoWindow: InfoWindow(title: conference.name),
        ));
      }
    }
    conferences.forEach((name, position) {
      _markers.add(
        Marker(
          markerId: MarkerId(name),
          position: position,
          infoWindow: InfoWindow(title: name),
        ),
      );
    });
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Local Conferences',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 20,
            )),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 10.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}
