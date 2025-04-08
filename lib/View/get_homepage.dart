import 'package:ammanbus/Resources/color_manager.dart';
 import 'package:ammanbus/View/choose_bus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Core/Provider/service_provider.dart';

class GetMainPage extends ConsumerWidget {
    GetMainPage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> GetUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
       title: const Text("Main Page",style: TextStyle(color: Colors.white),),
      ),
      drawer: Drawer(surfaceTintColor: Colors.white,

        child: Column(
          children: [
            // Your other drawer items
            DrawerHeader(child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                const Icon(Icons.person),
                FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                  future: GetUserDetails(),
                  builder: (context,Snapshot){
                    Map<String,dynamic>? user=Snapshot.data!.data();
                    return Text(user!['full name']);
                  },
                )
              ],)),
            // Add your widget in the bottom left corner
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(icon: Icon(Icons.logout,color: Colors.black87,),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(color: Colors.white,width: double.infinity,child: Image.asset("assets/images/mymap.jpg"),
          ),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.only(left: 50,right: 50),
            child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround,crossAxisAlignment:CrossAxisAlignment.center,children: [
              Column(children: [
                InkWell(child: _getColumnIcon(Icons.directions_bus_filled,"Book Bus"),onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){
                  return MyHomePage( title: "home page"  );
                }));},),
      const SizedBox(height: 10,)
                ,InkWell(child: _getColumnIcon(Icons.dashboard_sharp,"About Us"),onTap: (){},)



              ],),
              Column(children: [InkWell(child: _getColumnIcon(Icons.mail_sharp,"Contact Us"),onTap: (){},),
                const SizedBox(height: 10,)

                ,InkWell(child: _getColumnIcon(Icons.help,"Help"),onTap: (){},)],)
            ],),
          )
        ],
      ),);
  }

  Widget _getColumnIcon(IconData icon , String title)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(height: 120,width: 120,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color:  ColorManager.primary),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,size:50 ,),
                SizedBox(height: 10,),
                Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),)
              ],
          ),
        ),
      ),
    );
  }
}
