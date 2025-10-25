import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ElevatedButton(
          onPressed: () {
            print('Top button clicked!');
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Location: Blacksburg, VA'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Read Terms and Conditions'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('Click!');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Location: Blacksburg, VA'),
          ),
          const SizedBox(height: 20),
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
      description: 'Virginia Tech - Main Campus',
    ),
    MarkerData(
      id: 'marker_2',
      position: LatLng(37.2275, -80.4231),
      description: 'Downtown Blacksburg - Shopping and dining',
    ),
    MarkerData(
      id: 'marker_3',
      position: LatLng(37.2244, -80.4214),
      description: 'Blacksburg Municipal Park - Recreation area',
    ),
    MarkerData(
      id: 'marker_4',
      position: LatLng(37.2340, -80.4250),
      description: 'Lane Stadium - Virginia Tech Football',
    ),
    MarkerData(
      id: 'marker_5',
      position: LatLng(37.2308, -80.4187),
      description: 'Cassell Coliseum - Basketball arena',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.id),
          content: Text(data.description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
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