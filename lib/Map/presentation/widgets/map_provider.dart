import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../business_logic/home_cubit.dart';


class MapProvider extends StatelessWidget {
  const MapProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final mapCubit = BlocProvider.of<HomeCubit>(context);
        final size = MediaQuery.of(context).size;
        return Container(
          height: size.height*0.5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              FlutterMap(
                mapController: mapCubit.mapController,
                options: MapOptions(
                    center: LatLng(45.5231, -122.6765),
                    zoom: 13,
                    onTap: (pos, LatLng location) {
                      mapCubit.getTabbedMarker(location);
                      log('tapped: $location');
                    }),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=d5d82d2c45b64d378dac738d82410397',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: mapCubit.markers,
                  ),
                  if(state is HomeLoaded)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: mapCubit.polylinePoints,
                        strokeCap: StrokeCap.round,
                        strokeWidth: 4,
                        borderStrokeWidth: 1,
                        color: const Color.fromARGB(255, 196, 121, 209),
                        borderColor: Colors.black
                        )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height*0.012, right: size.height*0.012),
                child: FloatingActionButton(
                  heroTag: 'MAP_MY_LOCATION',
                  onPressed: () => mapCubit.getCurrentLocation(),
                  child: Icon(Icons.my_location, size: size.height*.03),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
