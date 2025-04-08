// ignore_for_file: prefer_const_constructors, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

 import 'get_homepage.dart';

import 'login_page.dart';
import 'auth_page.dart';
import 'homedriver.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {


            final User? currentUser=FirebaseAuth.instance.currentUser;
            Future<DocumentSnapshot<Map<String,dynamic>>> GetUserDetails() async{
              return await FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser!.email)
                  .get();
            }

            return FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
              future: GetUserDetails(),
              builder: (context,Snapshot){
                if (Snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                Map<String,dynamic>? user=Snapshot.data!.data();

                if(user!['role']=='driver'){
                  return DriverHome();
                }

                else{
                  return GetMainPage();
                }


              },
            );
          }
          else

            return AuthPage();
        },),
    );
  }
}