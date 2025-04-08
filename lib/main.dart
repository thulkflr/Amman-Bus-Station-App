// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, unused_import

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Core/Service/shared_pref.dart';
import 'Resources/theme_manager.dart';
import 'firebase_options.dart';
import 'View/mainpage.dart';

import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Prefs.init();
  runApp(ProviderScope(child: MyWidget()));
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      home: MainPage(),      theme: getAppTheme(),

    );
  }
}

