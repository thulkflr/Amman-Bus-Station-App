// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_local_variable, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Resources/color_manager.dart';

class RegPage extends StatefulWidget {
  final VoidCallback show_login_page;
  const RegPage({super.key, required this.show_login_page});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _EmailController=TextEditingController();
  final _PasswordController=TextEditingController();
  final _PasswordConfirmController=TextEditingController();
  final _FullNameController=TextEditingController();

  Future SignUp () async{

    if(passconFirmed()){
      try {
        if(_FullNameController!=null){
          final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _EmailController.text,
            password: _PasswordController.text,

          );
          CreateUserDocument(credential);
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }

  }

  Future CreateUserDocument(UserCredential? credential) async{
    if(credential!=null && credential.user!=null){
      await FirebaseFirestore.instance.collection("users").doc(credential.user!.email).set({
        "email":credential.user!.email,
        "full name":_FullNameController.text
      });
    }

  }

  bool passconFirmed(){
    if (_PasswordController.text.trim()==_PasswordConfirmController.text.trim()) {
      return true;
    }
    else {
      return false;
    }
  }


  @override
  void dispose() {
    _EmailController.dispose();
    _PasswordController.dispose();
    _PasswordConfirmController.dispose();
    _FullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body:SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bus_alert,size: 70,),
                SizedBox(height: 70,),
                Text("Sign Up!",
                    style: GoogleFonts.bebasNeue(fontSize:54)),
                SizedBox(height: 10,),
                Text("Register below with your details!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20
                  ),),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _FullNameController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:ColorManager.primary),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        hintText: "Full Name",
                        fillColor: Colors.grey[200],
                        filled: true
                    ),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _EmailController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.primary),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        hintText: "Email",
                        fillColor: Colors.grey[200],
                        filled: true
                    ),),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _PasswordController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.primary),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        hintText: "Password",
                        fillColor: Colors.grey[200],
                        filled: true
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _PasswordConfirmController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:ColorManager.primary),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        hintText: "Confirm Password",
                        fillColor: Colors.grey[200],
                        filled: true
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: SignUp,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color:ColorManager.primary,borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text("Sign Up",
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18))),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("I am a member! ",style: TextStyle(fontWeight: FontWeight.w300),),
                    GestureDetector(
                      onTap: widget.show_login_page,
                      child: Text("Login now",style:
                      TextStyle(color: ColorManager.primary,fontWeight: FontWeight.bold),),
                    )
                  ],
                )
              ],),
          ),
        ),
      ),
    );
  }
}