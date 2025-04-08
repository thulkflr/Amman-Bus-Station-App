
import 'package:ammanbus/Map/presentation/widgets/address_card.dart';
import 'package:ammanbus/Map/presentation/widgets/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Map/business_logic/home_cubit.dart';



class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getCurrentLocation(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tracking a Bus'),
        ),
        body: const SafeArea(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(12.0),
                  child: MapProvider()
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: AddressCard()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
