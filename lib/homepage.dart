import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    await this.mapboxMap?.location.updateSettings(
          LocationComponentSettings(enabled: false, showAccuracyRing: false),
        );
  }
Future<geo.Position> _determinePosition() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      throw Exception('Location services are disabled.');
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {

        throw Exception('Location permissions are denied');
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {

      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await geo.Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 100,
            child: MapWidget(
              cameraOptions: CameraOptions(
                center: Point(
                  coordinates:  Position(5.1, 52.5),
                ).toJson(),
                zoom: 6,
              ),
              mapOptions: MapOptions(pixelRatio: 1),
              key: const ValueKey("mapWidget"),
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
               geo.Position position = await _determinePosition();
              mapboxMap?.location.updateSettings(
                  LocationComponentSettings(enabled: true, pulsingEnabled: true));
              mapboxMap?.flyTo(CameraOptions(
                  center:
                      Point(coordinates: Position(position.longitude, position.latitude)).toJson(),
                  zoom: 13.0,
                  pitch: 30),
                  MapAnimationOptions(duration: 1750, startDelay: 0));
            },
            child: const Material(
              child: Center(
                child: Text(
                  'Show your location on the map',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
