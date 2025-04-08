import 'package:cloud_firestore/cloud_firestore.dart';

class PaYmentModel {
  String? cardID;
   String? expiryDate;
   String? cvv;
   String? cardHolder;
  bool? status;
  String? userId;


  PaYmentModel.name();

  PaYmentModel({
    this.cardID,
     required this.expiryDate,
    required this.cvv,
    required this.cardHolder,
      this.userId,
    required this.status,
  });

  Map<String, dynamic> toMap() {

    return <String, dynamic>{
      'cardID': cardID,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardHolder': cardHolder,
      'userId': userId,
      'status': status

    };
  }

  factory PaYmentModel.fromMap(Map<String, dynamic> map) {
    return PaYmentModel(
        cardID:
            map['cardID'] != null ? map['cardID'] as String : null,
        expiryDate: map['expiryDate'] as String,
        cvv: map['cvv'] as String,
        cardHolder: map['cardHolder'] as String,
        userId: map['userId'] as String,
        status: map['status'] as bool
        );
  }

  factory PaYmentModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapShot) {
    return PaYmentModel(
        cardID: documentSnapShot.id,
        expiryDate: documentSnapShot['expiryDate'],
        cvv: documentSnapShot['cvv'],
        cardHolder: documentSnapShot['cardHolder'],
        userId: documentSnapShot['userId'],
        status: documentSnapShot['status']
        );
  }
}
