import 'dart:async';
import 'dart:js_interop';

import 'package:ammanbus/Resources/color_manager.dart';
import 'package:ammanbus/View/map_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'book_interface.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFull_status = true;

  List<String> towns = [
    'ANY',
    'Amman',
    'Jarash',
    'Ajloun',
  ];
  List<Map<String, String>> data = [];
  String src = 'Amman Station', des = 'ANY';

  void setDes(String? t) {
    setState(() {
      des = t ?? towns[0];
    });
  }

  Future<bool> isFully() async {
     if (des == 'Ajloun') {
      var isFull = await FirebaseFirestore.instance
          .collection('bus_seats_for_ajloun')
          .doc('is_full')
          .get();
      print('${isFull['isFull']} this is full baby');
      return isFull['isFull'] as bool;
    } else if (des == 'Amman') {
      var isFull = await FirebaseFirestore.instance
          .collection('bus_seats_for_amman')
          .doc('is_full')
          .get();
      print('${isFull['isFull']} this is full baby');
      return isFull['isFull'] as bool;
    } else if (des == 'Jarash') {
      var isFull = await FirebaseFirestore.instance
          .collection('bus_seats_for_jarash')
          .doc('is_full')
          .get();
      print('${isFull['isFull']} this is full baby');
      return isFull['isFull'] as bool;
    } else {
      return 'false' as bool;
    }
  }

  Future search() async {

    setState(() {

      data.clear();
      List<Map<String, String>> items = [
        {
          'source': 'Irbid',
          'destination': 'Amman',
        },
        {'source': 'Irbid', 'destination': 'Jarash'},
        {'source': 'Irbid', 'destination': 'Ajloun'},
      ];

      // Filter data based on selected destination
      data.addAll(items.where((item) => item['destination'] == des));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SOURCE'),
                  SizedBox(height: 20),
                  Text(
                    "STATION",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DESTINATION'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                        value: des,
                        items: towns.map((element) {
                          return DropdownMenuItem(
                              value: element, child: Text(element));
                        }).toList(),
                        onChanged: setDes),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              color: ColorManager.primary,
              width: double.infinity,
              child: TextButton.icon(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: search,
                label: const Text(
                  'Search',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(),
              ),
            ),
          ),


          _getSection('Available Trip'),

          Container(
            height: 180,
            child: FutureBuilder(
              future: isFully(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                   return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                   return Center(child: Text('Choose your Destination',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),));

                } else {
                   bool isBusFullyBooked = snapshot.data ?? false;
                  print('Is bus fully booked? $isBusFullyBooked',);
                  if (isBusFullyBooked) {
                    return Center(child: Text('Sorry! The Bus is fully booked ):',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),));
                  } else {
                    return PageView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            child: BusCard(data: data[i]),
                            onTap: () {
                              print("${data[i]} this is data");
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Bus Road Map"),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Image.asset(
                                                  "assets/images/mymap.jpg")
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                print("${des} this is towns");

                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return BookingInterface(
                                                    chosen_line: des,
                                                  );
                                                }));
                                              },
                                              child: Text(
                                                  "Complete to book a seat?")),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Cancel"))
                                        ],
                                      ));
                            },
                          );
                        });
                  }
                }
              },
            ),
          ),
          _getSection("Trip Information"),
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) => InkWell(
                      child: AboutTripCard(data[i]),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MapScreen();
                        }));
                      },
                    )),
          ),
        ],
      ),
    );
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 2),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final Map<String, String> data;

  const BusCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: ColorManager.primary,
            borderRadius: BorderRadius.circular(12)),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SOURCE',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      data['source'] ?? '',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Amman Station",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '→',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'DESTINATION',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      data['destination'] ?? '',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['destination'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Icon(
                  Icons.directions,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    "30" + ' KM, via ' + "inter_towns",
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  Icons.directions_bus,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Toyota" + ', ' + "30" + ' seater, ' + " [Non-AC, AC  ac],",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "1AM ",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 16,
                ),
                const Icon(
                  Icons.timelapse_rounded,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "3H",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AboutTripCard extends StatelessWidget {
  final Map<String, String> data;

  AboutTripCard(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(12)),
            width: double.infinity,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SOURCE',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      Text(
                        data['source'] ?? '',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Amman Station",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '→',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'DESTINATION',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      Text(
                        data['destination'] ?? '',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data['destination'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.event_seat,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      "seat NO. 15",
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.directions_bus,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Toyota Coaster\n" +
                        'Bus Color : white' +
                        "\n" +
                        ' Bus NO. ' +
                        "   991991 \n Driver Name : Ahmad",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Click for Tracking ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ])));
  }
}
