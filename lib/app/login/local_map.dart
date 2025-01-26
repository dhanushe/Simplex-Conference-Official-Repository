import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../../api/objects/conference_data.dart';

class GoogleMapsPage extends StatefulWidget {
  final List<ConferenceData> conferences;

  GoogleMapsPage({required this.conferences});

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController mapController;
  final LatLng _initialPosition =
      LatLng(47.6062, -122.3321); // Washington coordinates
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadConferenceMarkers();
  }

  Future<void> _loadConferenceMarkers() async {
    Map<String, LatLng> _conferences = {
      'Tech Summit': LatLng(37.7749, -122.4194), // San Francisco, CA
      'Health Expo': LatLng(34.0522, -118.2437), // Los Angeles, CA
      'EduCon': LatLng(40.7128, -74.0060), // New York, NY
      'AI Conference': LatLng(42.3601, -71.0589), // Boston, MA
      'Cyber Security Summit': LatLng(38.9072, -77.0369), // Washington, D.C.
      'Green Energy Symposium': LatLng(47.6062, -122.3321), // Seattle, WA
      'Finance Forum': LatLng(41.8781, -87.6298), // Chicago, IL
      'Marketing Meetup': LatLng(29.7604, -95.3698), // Houston, TX
      'Gaming Expo': LatLng(36.1699, -115.1398), // Las Vegas, NV
      'Mobile World Congress': LatLng(32.7157, -117.1611), // San Diego, CA
      'Developer Week': LatLng(39.7392, -104.9903), // Denver, CO
      'StartUp Grind': LatLng(25.7617, -80.1918), // Miami, FL
      'Business Expo': LatLng(33.7490, -84.3880), // Atlanta, GA
      'Data Science Summit': LatLng(45.5152, -122.6784), // Portland, OR
      'Design Conference': LatLng(30.2672, -97.7431), // Austin, TX
      'Blockchain Symposium': LatLng(39.1031, -84.5120), // Cincinnati, OH
      'LegalTech Conference': LatLng(44.9778, -93.2650), // Minneapolis, MN
      'BioTech Summit': LatLng(40.4406, -79.9959), // Pittsburgh, PA
      'Smart Cities Expo': LatLng(33.4484, -112.0740), // Phoenix, AZ
      'Robotics Conference': LatLng(29.4241, -98.4936), // San Antonio, TX
      'VR/AR Summit': LatLng(32.7767, -96.7970), // Dallas, TX
      'E-commerce Expo': LatLng(39.7684, -86.1581), // Indianapolis, IN
      'Digital Transformation Forum':
          LatLng(37.3382, -121.8863), // San Jose, CA
      'Cloud Expo': LatLng(30.3322, -81.6557), // Jacksonville, FL
      'IoT Conference': LatLng(39.9612, -82.9988), // Columbus, OH
      'Wearable Tech Summit': LatLng(29.9511, -90.0715), // New Orleans, LA
      'AgriTech Conference': LatLng(38.2527, -85.7585), // Louisville, KY
      'Nanotech Expo': LatLng(35.2271, -80.8431), // Charlotte, NC
      'Quantum Computing Summit': LatLng(36.1627, -86.7816), // Nashville, TN
      'SpaceTech Symposium': LatLng(37.7749, -122.4194), // San Francisco, CA
      'MedTech Forum': LatLng(34.0522, -118.2437), // Los Angeles, CA
      'Insurance Tech Conference': LatLng(40.7128, -74.0060), // New York, NY
      'Construction Tech Expo': LatLng(42.3601, -71.0589), // Boston, MA
      'Automotive Tech Summit': LatLng(38.9072, -77.0369), // Washington, D.C.
      'Sports Tech Conference': LatLng(47.6062, -122.3321), // Seattle, WA
      'Food Tech Expo': LatLng(41.8781, -87.6298), // Chicago, IL
      'Music Tech Symposium': LatLng(29.7604, -95.3698), // Houston, TX
      'Tourism Tech Forum': LatLng(36.1699, -115.1398), // Las Vegas, NV
      'Education Innovation Summit':
          LatLng(32.7157, -117.1611), // San Diego, CA
      'Fashion Tech Conference': LatLng(39.7392, -104.9903), // Denver, CO
      'Retail Tech Expo': LatLng(25.7617, -80.1918), // Miami, FL
      'Hospitality Tech Summit': LatLng(33.7490, -84.3880), // Atlanta, GA
      'Transport Tech Conference': LatLng(45.5152, -122.6784), // Portland, OR
      'Real Estate Tech Forum': LatLng(30.2672, -97.7431), // Austin, TX
      'HR Tech Conference': LatLng(39.1031, -84.5120), // Cincinnati, OH
      'Sustainability Tech Expo': LatLng(44.9778, -93.2650), // Minneapolis, MN
      'Climate Change Summit': LatLng(40.4406, -79.9959), // Pittsburgh, PA
      'Logistics Tech Conference': LatLng(33.4484, -112.0740), // Phoenix, AZ
      'Entertainment Tech Symposium':
          LatLng(29.4241, -98.4936), // San Antonio, TX
      'Future of Work Forum': LatLng(32.7767, -96.7970), // Dallas, TX
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
    _conferences.forEach((name, position) {
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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Local Conferences',
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
