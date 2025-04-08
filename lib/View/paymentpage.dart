// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
//
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:ammanbus/Resources/color_manager.dart';
// import 'package:ammanbus/View/mainpage.dart';
//  import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
//
// class PaymentPage extends StatefulWidget {
//   final String seat_number;
//
//   PaymentPage({super.key, required this.seat_number});
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final GlobalKey globalKey = GlobalKey();
//   bool dirExist = false;
//   dynamic externalDir = '/storage/emulated/0/Download/Qr_Code';
//   final User? currentUser = FirebaseAuth.instance.currentUser;
//
//   String cardNumber = "";
//   String expiryDate = "";
//   String cardHolderName = "";
//   String cvvCode = "";
//   bool isCvvFocused = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//          title: Text(
//           "Checkout",
//           style: TextStyle(color: Colors.white),
//         ),
//
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             CreditCardWidget(
//                 cardBgColor:ColorManager.primary,
//                 cardNumber: cardNumber,
//                 expiryDate: expiryDate,
//                 cardHolderName: cardHolderName,
//                 cvvCode: cvvCode,
//                 showBackView: isCvvFocused,
//                 onCreditCardWidgetChange: (p0) {}),
//             CreditCardForm(
//                 cardNumber: cardNumber,
//                 expiryDate: expiryDate,
//                 cardHolderName: cardHolderName,
//                 cvvCode: cvvCode,
//                 onCreditCardModelChange: (data) {
//                   setState(() {
//                     cardNumber = data.cardNumber;
//                     expiryDate = data.expiryDate;
//                     cardHolderName = data.cardHolderName;
//                     cvvCode = data.cvvCode;
//                   });
//                 },
//                 formKey: formKey),
//             SizedBox(
//               height: 20,
//             ),
//             MaterialButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                             title: const Text("Confirm Payment"),
//                             content: SingleChildScrollView(
//                               child: ListBody(
//                                 children: [
//                                   Text("Card Number: $cardNumber"),
//                                   Text("Expiry Date: $expiryDate"),
//                                   Text("Card Holder Name: $cardHolderName"),
//                                   Text("Cvv: $cvvCode"),
//                                   Text(currentUser!.email!),
//                                   getQRCode(context, currentUser!.email!)
//                                 ],
//                               ),
//                             ),
//                             actions: [
//                               TextButton(
//                                   onPressed: ()   {
//                                       _captureAndSaving();
//                                     setState(() {
//                                       dirExist = true;
//                                     });
//                                   },
//                                   child: Text("QR Download")),
//
//                               TextButton(
//                                   onPressed: (dirExist != true)
//                                       ? () => Navigator.pushAndRemoveUntil(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     MainPage()),
//                                             (route) =>
//                                                 false, // Always return false to remove all routes
//                                           )
//                                       : null,
//                                   child: Text("Yes")),
//                               TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: Text("Cancel"))
//                             ],
//                           ));
//                 }
//               },
//               minWidth: 300,
//               child: Text('Pay Now'),
//               color: ColorManager.primary,
//               textColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius:
//                     BorderRadius.circular(20.0), // Adjust the value as needed
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getQRCode(BuildContext context, String email) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 20,
//         ),
//         RepaintBoundary(
//           key: globalKey,
//           child: Container(
//             height: 150,
//             width: 150,
//             color: Colors.white,
//             child: Center(
//               child: email.isEmpty
//                   ? Text("Something went wrong please retry again ")
//                   : QrImageView(
//                       data: email,
//                       version: QrVersions.auto,
//                       size: 150,
//                      ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _captureAndSaving() async {
//     try {
//       RenderRepaintBoundary boundary =
//           globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       var image = await boundary.toImage(pixelRatio: 3.0);
//
// //drawing white background
//       final whitePaint = Paint()..color = Colors.white;
//       final recorder = PictureRecorder();
//       final canvas = Canvas(recorder,
//           Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
//       canvas.drawRect(
//           Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
//           whitePaint);
//
//       canvas.drawImage(image, Offset.zero, Paint());
//       final picture = recorder.endRecording();
//       final img = await picture.toImage(image.width, image.height);
//       ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
//       Uint8List? pngByte = byteData?.buffer.asUint8List();
//
//       //check for  duplicate file name to avoid override
//       String fileName = 'qr_code';
//       int i = 1;
//       while (await File('$externalDir/$fileName.png').exists()) {
//         fileName = 'qr_code_$i';
//         i++;
//       }
//
//       // check if directory path exist or not
//       dirExist = await File(expiryDate).exists();
//       //if not then create the path
//       if (!dirExist) {
//         await Directory(externalDir).create(recursive: true);
//         dirExist = true;
//       }
//
//       final file = await File('$externalDir/$fileName.png').create();
//       await file.writeAsBytes(pngByte!);
//
//       if (!mounted) return;
//       const snackBar = SnackBar(content: Text('the QR Code saved at gallery'));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     } catch (error) {
//       if (!mounted) return;
//       const snackBar =
//           SnackBar(content: Text('Something went wrong! please retry again'));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }
// }
