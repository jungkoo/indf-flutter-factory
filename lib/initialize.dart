
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationInstance {
  static final LocationInstance _instance = LocationInstance._internal();
  final LatLng _seoulCityHall = LatLng(37.5662952, 126.9779451);
  LatLng? _currentLocation;

  factory LocationInstance() {
    return _instance;
  }

  /*
   * Main 에서 선 초기화 필요함
   * await SupabaseInstance().initialize(url, key);
   */
  initialize(LatLng location)  {
    _currentLocation = location;
  }

  LocationInstance._internal();

  Future<LatLng> currentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      debugPrint("위치 권한이 영구히 거부된 상태임");
      return _currentLocation??_seoulCityHall;
    }
    // 권한이 없을 때 권한 요청 시도
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      final currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _currentLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
      return _currentLocation!;
    }

    return _currentLocation??_seoulCityHall;
  }
}


class SupabaseInstance {

  static final SupabaseInstance _instance = SupabaseInstance._internal();

  factory SupabaseInstance() {
    return _instance;
  }

  /*
   * Main 에서 선 초기화 필요함
   * await SupabaseInstance().initialize(url, key);
   */
  initialize(String url, String key) async {
    await Supabase.initialize(
      url: url,
      anonKey: key,
    );
  }

  SupabaseInstance._internal();

  SupabaseClient get client => Supabase.instance.client;
}