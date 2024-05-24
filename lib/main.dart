import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_poc/homepage.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(
      'ACCES TOKEN HERE');

  await Permission.location.request();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapbox map ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FullMap(),
    );
  }
}