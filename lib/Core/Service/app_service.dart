// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:todo_app/Models/todo_model.dart';
//
// class Todo_Service {
//   int statusCode = 0;
//   String msg = '';
//   final collection = FirebaseFirestore.instance.collection('todoApp');
//
//   //create service function
//
//   void addNewTask(TODO_Model model) {
//     collection.add(model.toMap());
//
//
//   }
//   //update service function
//   void updateTask(String? docID, bool? valueUpdate) {
//     collection.doc(docID).update({
//       'status': valueUpdate,
//     });
//   }
//
//   //delete service function
//   void deleteTask(String? docID ) {
//     collection.doc(docID).delete();
//   }
//   void handleAuthErrors(ArgumentError error) {
//     String errorCode = error.message;
//     switch (errorCode) {
//       case "ABORTED":
//         {
//           statusCode = 400;
//           msg = "The operation was aborted";
//         }
//         break;
//       case "ALREADY_EXISTS":
//         {
//           statusCode = 400;
//           msg = "Some document that we attempted to create already exists.";
//         }
//         break;
//       case "CANCELLED":
//         {
//           statusCode = 400;
//           msg = "The operation was cancelled";
//         }
//         break;
//       case "DATA_LOSS":
//         {
//           statusCode = 400;
//           msg = "Unrecoverable data loss or corruption.";
//         }
//         break;
//       case "PERMISSION_DENIED":
//         {
//           statusCode = 400;
//           msg =
//           "The caller does not have permission to execute the specified operation.";
//         }
//         break;
//       default:
//         {
//           statusCode = 400;
//           msg = error.message;
//         }
//         break;
//     }
//     log('msg : $msg');
//   }
// }

import 'dart:developer';

import 'package:ammanbus/Core/Service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../Consts/consts.dart';
import '../Models/todo_model.dart';

class AmmanBus_Service {
  int statusCode = 0;
  String msg = '';
  final FirebaseFirestore collection = FirebaseFirestore.instance;

  final String collectionName = 'payment';

  //create service function

  Future<bool> addPayment(PaYmentModel model) async {
    try {
      await collection
          .collection(collectionName)
          .add(model.toMap())
          .catchError((err) {
        handleAuthErrors(err);
      });
      return true;
    } on Exception catch (error) {
      log('error : $error');
      return false;
    }
  }

  //update service function
  Future<void> updateTask(String? docID, bool? valueUpdate) async {
    try {
      await collection
          .collection(collectionName)
          .doc(docID)
          .update({'status': valueUpdate}).catchError((err) {
        handleAuthErrors(err);
      });
    } on Exception catch (error) {
      log('error : $error');
    }
  }

//delete service function
  Future<void> deleteTask(String? docID) async {
    try {
      await collection
          .collection(collectionName)
          .doc(docID)
          .delete()
          .catchError((onError) {
        handleAuthErrors(onError);
      });
    } on Exception catch (error) {
      log('error: $error');
    }
  }

  Future<List<PaYmentModel>> getTasks() async {
    try {
      QuerySnapshot query = await collection
          .collection(collectionName)
          .where('userId', isEqualTo: Prefs.getStringValue(userIDPrefs))
          .get()
          .catchError((err) {
        handleAuthErrors(err);
      });

      List<PaYmentModel> result = [];
      for (var item in query.docs) {
        var data = PaYmentModel.name();
        data.cardID = item.get('cardID');
        data.expiryDate = item.get('expiryDate');
        data.cvv = item.get('cvv');
        data.cardHolder = item.get('cardHolder');
         data.status = item.get('status');
        result.add(data);
      }
      return result;
    } on Exception catch (error) {
      log('error : $error');
      return [];
    }
  }

  void handleAuthErrors(ArgumentError error) {
    String errorCode = error.message;
    switch (errorCode) {
      case "ABORTED":
        {
          statusCode = 400;
          msg = "The operation was aborted";
        }
        break;
      case "ALREADY_EXISTS":
        {
          statusCode = 400;
          msg = "Some document that we attempted to create already exists.";
        }
        break;
      case "CANCELLED":
        {
          statusCode = 400;
          msg = "The operation was cancelled";
        }
        break;
      case "DATA_LOSS":
        {
          statusCode = 400;
          msg = "Unrecoverable data loss or corruption.";
        }
        break;
      case "PERMISSION_DENIED":
        {
          statusCode = 400;
          msg =
              "The caller does not have permission to execute the specified operation.";
        }
        break;
      default:
        {
          statusCode = 400;
          msg = error.message;
        }
        break;
    }
    log('msg : $msg');
  }
}
