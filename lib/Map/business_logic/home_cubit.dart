import 'dart:developer';
import 'package:ammanbus/Map/services/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:geolocator/geolocator.dart';
 import 'package:latlong2/latlong.dart';

import '../services/map_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with MapServicesH {
  HomeCubit() : super(HomeInitial());

  final mapController = MapController();
  late Position currentLocation;
  List<LatLng> polylinePoints = [];
  Address? currentAddress;

  List<Marker> markers = [];

  Future getCurrentLocation() async {
    emit(HomeLoading());
    try {
      currentLocation = await getLocation();
      mapController.move(currentLocation.toLatLng(), 12);
      markers = getMarker(currentLocation.toLatLng());
      currentAddress = await getAddressFromLatLng(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude);
      polylinePoints = await getPolyLine();
      emit(HomeLoaded());
    } catch (e) {
      log('$e');
      emit(HomeError());
    }
    log('position: $currentLocation');
  }

  void getTabbedMarker(LatLng location) async {
    emit(AddressLoading());
    markers = getMarker(location);
    currentAddress = await getAddressFromLatLng(
        latitude: location.latitude, longitude: location.longitude);
    emit(AddressLoaded());
  }



}
