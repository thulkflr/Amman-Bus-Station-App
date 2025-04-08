import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:ammanbus/View/choose_bus.dart';
import 'package:ammanbus/Core/Models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../Resources/color_manager.dart';

class PaymentModel extends StatefulWidget {
  final int seat_number;
final String destination;
final bool isFull;
  PaymentModel( {required this.seat_number, Key? key, required this.destination, required this.isFull}) : super(key: key);

  @override
  State<PaymentModel> createState() => _PaymentModelState();
}

class _PaymentModelState extends State<PaymentModel> {
  final formKey = GlobalKey<FormState>();

  final GlobalKey globalKey = GlobalKey();
  PaYmentModel? paYmentModel;
  bool dirExist = false;

  dynamic externalDir = '/storage/emulated/0/Download/Qr_Code';

  final User? currentUser = FirebaseAuth.instance.currentUser;

  bool? isReserved ;
  String? cardNumber ;
  String? expiryDate ;
  String? cardHolderName  ;
  String? cvvCode ;
  bool? isCvvFocused = false;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'Your Session ID from Twilio',
    authToken: 'Token number from Twilio',
    twilioNumber: 'Twilio Number',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Payment Method',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              thickness: 1.2,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              height: 12,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  CreditCardWidget(
                    cardBgColor: ColorManager.primary,
                    cardNumber: cardNumber ?? '',
                    expiryDate: expiryDate ?? '',
                    cardHolderName: cardHolderName??'',
                    cvvCode: cvvCode??'',
                    showBackView: isCvvFocused??false,

                    onCreditCardWidgetChange: (p0) {},
                  ),
                  CreditCardForm(
                    cardNumber: cardNumber ?? '',
                    expiryDate: expiryDate ?? '',
                    cardHolderName: cardHolderName ?? '',
                    cvvCode: cvvCode ?? '',
                    onCreditCardModelChange: (data) {
                      setState(() {
                        cardNumber = data.cardNumber;
                        expiryDate = data.expiryDate;
                        cardHolderName = data.cardHolderName;
                        cvvCode = data.cvvCode;
                      });
                    },
                    formKey: formKey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: ()async{ if (formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirm Payment"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text("Card Number: $cardNumber"),
                                  Text("Expiry Date: $expiryDate"),
                                  Text(
                                      "Card Holder Name: $cardHolderName"),
                                  Text("Cvv: $cvvCode"),
                                  Text(currentUser!.email!),
                                  getQRCode(context, currentUser!.email!)
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _captureAndSaving();
                                    setState(() {
                                      dirExist = true;
                                    });
                                  },
                                  child: const Text("QR Download")),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12)),
                                  onPressed: () async{
                                    await  UpdateSeatStatus(widget.seat_number);
                                     {
                                      if (formKey.currentState!.validate()) {
                                        final paymentData = {
                                          'cardNumber': cardNumber,
                                          'expiryDate': expiryDate,
                                          'cardHolderName': cardHolderName,
                                          'cvvCode': cvvCode,
                                          'email': currentUser!.email,
                                        };

                                        try {
                                          await _firestore.collection('payment').add(paymentData);
                                          isReserved=true;
                                        await sendTripInfoMessage("your  mobile number");

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Payment confirmed, check your SMS')),
                                          );

                                          Navigator.pop(context);
                                        } catch (error) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Failed to confirm payment')),
                                          );
                                        }
                                      }
                                    }
                                    //


                                     Navigator.pushAndRemoveUntil(
                                       context,
                                       MaterialPageRoute(builder: (context) => MyHomePage(title: "home page" )),
                                           (route) => false, // Always return false to remove all routes
                                     );
                                  },
                                  // Always return false to remove all routes

                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"))
                            ],
                          ));
                    }}
                 ,   minWidth: 300,
                    color: ColorManager.primary,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text('Pay Now'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> UpdateSeatStatus(int index) async{
    if(widget.destination=="Amman"){
      await FirebaseFirestore.instance
          .collection("bus_seats_for_amman")
          .doc("seat_${index.toString()}")
          .update({"reserved": true});
    }else if(widget.destination=="Jarash"){
      await FirebaseFirestore.instance
          .collection("bus_seats_for_jarash")
          .doc("seat_${index.toString()}")
          .update({"reserved": true});
    }if(widget.destination=="Ajloun"){
      await FirebaseFirestore.instance
          .collection("bus_seats_for_ajloun")
          .doc("seat_${index.toString()}")
          .update({"reserved": true});
    }
  }
  Widget getQRCode(BuildContext context, String email) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        RepaintBoundary(
          key: globalKey,
          child: Container(
            height: 150,
            width: 150,
            color: Colors.white,
            child: Center(
              child: email.isEmpty
                  ? const Text("Something went wrong please retry again ")
                  : QrImageView(
                data: email,
                version: QrVersions.auto,
                size: 150,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> sendTripInfoMessage(String recipient) async {
    try {
      await twilioFlutter.sendSMS(
        toNumber: recipient,
        messageBody: 'Your trip information:\n'
            'Destination: ${widget.destination}\n'
            'Seat Number: ${widget.seat_number}\n'
            'Departure Time: ${TimeOfDay.minutesPerHour}\n'
        'Bus Driver Name: عمو سامي',
        // Add departure time
      );
      print('Message sent successfully!');
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  Future<void> _captureAndSaving() async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);

      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List? pngByte = byteData?.buffer.asUint8List();

      String fileName = 'qr_code';
      int i = 1;
      while (await File('$externalDir/$fileName.png').exists()) {
        fileName = 'qr_code_$i';
        i++;
      }

      dirExist = await File(expiryDate!).exists();
      if (!dirExist) {
        await Directory(externalDir).create(recursive: true);
        dirExist = true;
      }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngByte!);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('the QR Code saved at gallery')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong! please retry again')),
      );
    }
  }
}
