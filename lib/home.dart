import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marthon_map/log_screen.dart';
import 'data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    updateMarkers();
    super.initState();
  }

  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  Set<LatLng> markerLatLng = {};
  Marker marker = const Marker(
      point: LatLng(37.0902, -95.7129),
      child: Icon(Icons.check, color: Colors.green, size: 40));
  Map<String, LatLng> stateLatLong = {
    'Alabama': const LatLng(32.806671, -86.791130),
    'Alaska': const LatLng(61.370716, -149.493686),
    'Arizona': const LatLng(33.729759, -111.431221),
    'Arkansas': const LatLng(34.969704, -92.373123),
    'California': const LatLng(36.7783, -119.4179),
    'Colorado': const LatLng(39.550051, -105.782067),
    'Connecticut': const LatLng(41.603221, -73.087749),
    'Delaware': const LatLng(38.910832, -75.52767),
    'Florida': const LatLng(27.9944024, -81.7602544),
    'Georgia': const LatLng(33.040433, -83.6430735),
    'Hawaii': const LatLng(21.094318, -157.498337),
    'Idaho': const LatLng(44.299782, -114.742041),
    'Illinois': const LatLng(40.633125, -89.398528),
    'Indiana': const LatLng(39.717600, -86.381267),
    'Iowa': const LatLng(41.875549, -93.597701),
    'Kansas': const LatLng(38.526600, -96.726486),
    'Kentucky': const LatLng(38.416100, -84.670067),
    'Louisiana': const LatLng(31.168108, -91.869334),
    'Maine': const LatLng(44.693947, -69.381927),
    'Maryland': const LatLng(39.063946, -76.802101),
    'Massachusetts': const LatLng(42.230171, -71.530106),
    'Michigan': const LatLng(42.165726, -84.620213),
    'Minnesota': const LatLng(46.299611, -94.419634),
    'Mississippi': const LatLng(32.741646, -89.678696),
    'Missouri': const LatLng(36.116203, -89.971086),
    'Montana': const LatLng(46.92818, -110.454353),
    'Nebraska': const LatLng(41.125370, -98.268082),
    'Nevada': const LatLng(38.313515, -117.055374),
    'New Hampshire': const LatLng(43.416745, -71.411818),
    'New Jersey': const LatLng(40.298904, -74.521011),
    'New Mexico': const LatLng(34.840515, -106.248482),
    'New York': const LatLng(40.712775, -74.005973),
    'North Carolina': const LatLng(35.630066, -79.806419),
    'North Dakota': const LatLng(47.528912, -99.784012),
    'Ohio': const LatLng(40.388783, -82.764915),
    'Oklahoma': const LatLng(35.565342, -96.928917),
    'Oregon': const LatLng(44.299782, -118.243684),
    'Pennsylvania': const LatLng(40.590752, -77.209755),
    'Rhode Island': const LatLng(41.680894, -71.511780),
    'South Carolina': const LatLng(33.856892, -80.945007),
    'South Dakota': const LatLng(44.299782, -99.438828),
    'Tennessee': const LatLng(35.747845, -86.692345),
    'Texas': const LatLng(31.9685988, -99.9018131),
    'Utah': const LatLng(40.1135, -111.8535),
    'Vermont': const LatLng(44.045876, -72.710686),
    'Virginia': const LatLng(37.769337, -78.169968),
    'Washington': const LatLng(47.400902, -121.490494),
    'West Virginia': const LatLng(38.491226, -80.954049),
    'Wisconsin': const LatLng(43.78444, -88.787868),
    'Wyoming': const LatLng(43.07597, -107.290287),
  };

  String? _selectedState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: _addMaraton, child: const Icon(Icons.add)),
            const Text("Marathon Map"),
            ElevatedButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Logscreen()),
                    ),
                child: const Text('Logs')),
          ],
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(37.0902, -95.7129),
              initialZoom: 3.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: _addMarkers(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addMaraton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add your Marathon!"),
          actions: [
            const Row(
              children: [
                Text("State"),
              ],
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select state',
              ),
              value: _selectedState,
              items: states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                });
              },
            ),
            const Row(
              children: [
                Text("Time"),
              ],
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter time',
              ),
            ),
            const Row(
              children: [
                Text("Heart Rate"),
              ],
            ),
            TextField(
              controller: _heartRateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter heart rate',
              ),
            ),
            const Row(
              children: [
                Text("Extra Info"),
              ],
            ),
            TextField(
              maxLines: 3,
              controller: _otherController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Other',
                  alignLabelWithHint: true),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    _uploadData(
                      _selectedState ?? '',
                      _timeController.text,
                      _heartRateController.text,
                      _otherController.text,
                    ).then((_) {
                      _selectedState = null;
                      _timeController.clear();
                      _heartRateController.clear();
                      _otherController.clear();
                      setState(() {});
                    });
                  },
                  child: const Text("Add"),
                ),
                const SizedBox(width: 170),
                TextButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectedState = null,
                    _timeController.clear(),
                    _heartRateController.clear(),
                    _otherController.clear(),
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadData(
      String state, String time, String heartRate, String extraInfo) async {
    LatLng? latLngUpload;

    if (state.isNotEmpty) {
      LatLng? latLng = stateLatLong[state];
      if (latLng != null) {
        latLngUpload = latLng;
      } else {
        log('State $state not found in the map.');
      }

      FirebaseFirestore.instance.collection('Marathons').add({
        'state': state,
        'time': time,
        'heartRate': heartRate,
        'extraInfo': extraInfo,
        'lat': latLngUpload?.latitude,
        'lng': latLngUpload?.longitude,
      }).then((value) {
        Navigator.of(context).pop();
      }).catchError((error) {
        log("Failed to add entry: $error");
      });
    }
    updateMarkers();
  }

  Future<List<Map<String, dynamic>>> getCollection() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Marathons').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> updateMarkers() async {
    List<Map<String, dynamic>> data = await getCollection();
    markerLatLng.clear();
    for (var doc in data) {
      double latitude = doc['lat'] ?? 0;
      double longitude = doc['lng'] ?? 0;
      LatLng latLng = LatLng(latitude, longitude);
      if (latLng != const LatLng(0, 0)) {
        markerLatLng.add(latLng);
      }
    }
    setState(() {});
  }

  List<Marker> _addMarkers() {
    List<Marker> toBeReturned = [];
    for (var latlng in markerLatLng) {
      Marker createdMarker = Marker(
          point: latlng,
          child: const Icon(Icons.check, color: Colors.green, size: 40));
      toBeReturned.add(createdMarker);
    }
    return toBeReturned;
  }
}
