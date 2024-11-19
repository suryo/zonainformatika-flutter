import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = LatLng(-6.1751, 106.8650); // Koordinat Jakarta sebagai contoh
  String _address = '';

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations[0];
        setState(() {
          _currentLocation = LatLng(location.latitude, location.longitude);
          _mapController.move(_currentLocation, 15.0);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map With Geocoding',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Map widget
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(-7.3067923774299635, 112.79294745637897), // Gunakan initialCenter
                initialZoom: 16.0, // Gunakan initialZoom
                onTap: (tapPosition, point) {
                  setState(() {
                    _currentLocation = point;
                  });
                  _getAddressFromLatLng(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(-7.3067923774299635, 112.79294745637897),
                      width: 50,
                      height: 50,
                      child: Icon(Icons.location_on, color: Colors.red),

                    ),
                  ],
                ),
              ],
            ),
          ),
          // Address input and search button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter an address',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    _getLatLngFromAddress(value);
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Address: $_address',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
