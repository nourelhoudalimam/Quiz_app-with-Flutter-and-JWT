


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_jwtapp/View/ListNotes.dart';
import 'package:my_jwtapp/View/home.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp( options: FirebaseOptions(databaseURL: 'https://jwtshare-86dbe-default-rtdb.europe-west1.firebasedatabase.app/',apiKey: "AIzaSyCm9-DB5iOhW4yalm5CqiL252X2aOgv9M4", appId: "1:818391468975:android:d3a6c82cc081de0215fd5a", messagingSenderId:"818391468975", projectId: "jwtshare-86dbe"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD App',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home:  ListNotes(),
    );
  }
}
