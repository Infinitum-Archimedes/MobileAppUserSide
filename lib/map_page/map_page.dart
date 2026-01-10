import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              border: Border(bottom: BorderSide(color: colorScheme.shadow, width: 1)),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: colorScheme.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Location: Blacksburg, VA',
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implement location change
                  },
                  child: Text(
                    'Change',
                    style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
            ),
            child: Center(
              child: Text(
                'Read Terms and Conditions',
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const Expanded(
            child: MapPageDisplay(),
          ),
        ],
      ),
    );
  }
}

class MapPageDisplay extends StatefulWidget {
  const MapPageDisplay({Key? key}) : super(key: key);

  @override
  State<MapPageDisplay> createState() => _MapPageDisplayState();
}

class _MapPageDisplayState extends State<MapPageDisplay> {
  GoogleMapController? mapController;

  // Initial camera position - Blacksburg, VA
  static const LatLng _center = LatLng(37.2296, -80.4139);

  // Array of marker data with coordinates and descriptions
  final List<MarkerData> markerDataList = [
    MarkerData(
      id: 'marker_1',
      position: LatLng(37.2296, -80.4139),
      description: 'Covid-19 Reported',
    ),
    MarkerData(
      id: 'marker_2',
      position: LatLng(37.2275, -80.4231),
      description: 'Allergy Reported',
    ),
    MarkerData(
      id: 'marker_3',
      position: LatLng(37.2244, -80.4214),
      description: 'Fever Reported',
    ),
    MarkerData(
      id: 'marker_4',
      position: LatLng(37.2340, -80.4250),
      description: 'AIDS Reported',
    ),
    MarkerData(
      id: 'marker_5',
      position: LatLng(37.2308, -80.4187),
      description: 'Fungal Infection',
    ),
  ];

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = markerDataList.map((data) {
      return Marker(
        markerId: MarkerId(data.id),
        position: data.position,
        infoWindow: InfoWindow(
          title: data.id,
          snippet: data.description,
        ),
        onTap: () {
          _showMarkerDialog(data);
        },
      );
    }).toSet();
  }

  void _showMarkerDialog(MarkerData data) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            data.description,
            style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Health report in this area',
            style: TextStyle(color: colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: colorScheme.secondary)),
            ),
          ],
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: _center,
        zoom: 13.0,
      ),
      markers: _markers,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      // For web: Add your Map ID from Google Cloud Console to use Advanced Markers
      // cloudMapId: 'YOUR_MAP_ID_HERE',
    );
  }
}

// Data class to hold marker information
class MarkerData {
  final String id;
  final LatLng position;
  final String description;

  MarkerData({
    required this.id,
    required this.position,
    required this.description,
  });
}
