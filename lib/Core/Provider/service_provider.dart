// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../Consts/consts.dart';
// import '../Models/todo_model.dart';
// import '../Service/shared_pref.dart';
// import '../Service/app_service.dart';
//
// final serviceProvider = StateProvider<AmmanBus_Service>((ref) {
//   return AmmanBus_Service();
// });
//
// final sstreamProvider = StreamProvider<List<PaYmentModel>>((ref) async* {
// //  for show list of cards
//
//   final getData = FirebaseFirestore.instance
//       .collection('ammanBus')
//       .where('userId', isEqualTo: Prefs.getStringValue(userIDPrefs))
//       .snapshots()
//       .map((event) =>
//           event.docs.map((e) => PaYmentModel.fromSnapShot(e)).toList());
//   yield* getData;
// });
