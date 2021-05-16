import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseinterface/home.dart';
import 'package:flutter/material.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  }

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirestoreCRUDPage(),
    );
  }
}
