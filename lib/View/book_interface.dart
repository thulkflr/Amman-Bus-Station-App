import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Resources/color_manager.dart';
import 'dialog_card.dart';
class BookingInterface extends StatefulWidget {
  final String chosen_line;
  bool isFull = false;
  bool isFull1 = false;
  bool isFull2 = false;


  BookingInterface({super.key, required this.chosen_line});

  @override
  State<BookingInterface> createState() => _BookingInterfaceState();
}

List<int> seats = [
  1,
  2,
  3,
  4,
  5,
];

class _BookingInterfaceState extends State<BookingInterface> {
  Future<void> checkFullStatus() async {

    bool allSeatsBooked = true;

    for (int seat in seats) {
      if (!await SeatStatus(seat)) {
        allSeatsBooked = false;
        break;
      }
    }

    setState(()   {
      widget.isFull =   allSeatsBooked ;
      widget.isFull1 =   allSeatsBooked ;
      widget.isFull2 =   allSeatsBooked ;

    });

  }
  @override
  void initState() {
    super.initState();
    checkFullStatus(); // Check full status when the widget initializes
  }
  bool seat_status = true;
  bool full_status = true;

  //////check seat is reserved or not//////////////
  Future<bool> SeatStatus(int index) async {
    print("${widget.isFull}:: this is full check");

    if (widget.chosen_line == "Amman") {
      if(widget.isFull1){
        await FirebaseFirestore.instance
            .collection('bus_seats_for_amman')
            .doc("is_full")
            .set({'isFull': widget.isFull1});
      }else{
        await FirebaseFirestore.instance
            .collection('bus_seats_for_amman')
            .doc("is_full")
            .set({'isFull':false});
      }
      bool isReserved = false;

      await FirebaseFirestore.instance
          .collection('bus_seats_for_amman')
          .doc("seat_${index.toString()}")
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Seat document found
          var seatData = documentSnapshot.data() as Map<String, dynamic>;
          isReserved = seatData['reserved'];

          if (!isReserved) {
            // Seat is available
            seat_status = false;
          } else {
            // Seat is occupied
            seat_status = true;
          }
        }
      }).catchError((error) {
        print('Error fetching data: $error');
      });
      return seat_status;
    } else if (widget.chosen_line == "Jarash") {
      bool isReserved = false;
      if(widget.isFull){
        await FirebaseFirestore.instance
            .collection('bus_seats_for_jarash')
            .doc("is_full")
            .set({'isFull': widget.isFull});
      }else{
        await FirebaseFirestore.instance
            .collection('bus_seats_for_jarash')
            .doc("is_full")
            .set({'isFull':false});
      }
      await FirebaseFirestore.instance
          .collection('bus_seats_for_jarash')
          .doc("seat_${index.toString()}")
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Seat document found
          var seatData = documentSnapshot.data() as Map<String, dynamic>;
          isReserved = seatData['reserved'];

          if (!isReserved) {
            // Seat is available
            seat_status = false;
          } else {
            // Seat is occupied
            seat_status = true;
          }
        }
      }).catchError((error) {
        print('Error fetching data: $error');
      });
      return seat_status;
    } else if (widget.chosen_line == "Ajloun") {
      bool isReserved = false;
      if(widget.isFull2){
        await FirebaseFirestore.instance
            .collection('bus_seats_for_ajloun')
            .doc("is_full")
            .set({'isFull': widget.isFull2});
      }else{
        await FirebaseFirestore.instance
            .collection('bus_seats_for_ajloun')
            .doc("is_full")
            .set({'isFull':false});
      }
      await FirebaseFirestore.instance
          .collection('bus_seats_for_ajloun')
          .doc("seat_${index.toString()}")
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Seat document found
          var seatData = documentSnapshot.data() as Map<String, dynamic>;
          isReserved = seatData['reserved'];

          if (!isReserved) {
            // Seat is available
            seat_status = false;
          } else {
            // Seat is occupied
            seat_status = true;
          }
        }
      }).catchError((error) {
        print('Error fetching data: $error');
      });
      return seat_status;
    } else {
      return false;
    }
  }

  /////////check seat is reserved or not//////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            'Book a seat',
            style: TextStyle(color: Colors.white),
          )),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey),
                            width: 25,
                            height: 25),
                        const Text("Empty"),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorManager.primary,
                            ),
                            width: 25,
                            height: 25),
                        Text("Reserved"),
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                    seat_number(seats[index], widget.chosen_line),
                itemCount: seats.length,
              ),
              if (widget.isFull) // Display message if all seats are booked
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'All seats are booked!',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget seat_number(int number, String destination) {
    {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () async {
              if (!await SeatStatus(number)) {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    context: context,
                    builder: (context) => PaymentModel(
                      seat_number: number,
                      destination: destination,
                      isFull: widget.isFull,
                    ));
              }
            },
            child: FutureBuilder<bool>(
              future: SeatStatus(number),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for data, show a loading indicator
                  return const CircularProgressIndicator(
                    strokeAlign: 5,
                    color: Colors.black,
                  );
                } else if (snapshot.hasError) {
                  // If an error occurs, display an error message
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Once data is fetched, return the Container with the appropriate color
                  bool isOccupied = snapshot.data ?? true;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                          isOccupied ? ColorManager.primary : Colors.grey),
                      width: 35,
                      height: 35,
                      child: Center(
                          child: Text(
                            "$number",
                            style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                          )),
                    ),
                  );
                }
              },
            )),
      );
    }
  }
}
