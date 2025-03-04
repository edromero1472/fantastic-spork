import 'package:flutter/material.dart';
import 'package:google_maps_yt/pages/map_page.dart';
import 'package:google_maps_yt/pages/map_search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MapSearchPage(),
    );
  }
}
