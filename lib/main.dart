import 'package:flutter/material.dart';
import 'package:four_aba_project/login_page.dart';
import 'package:four_aba_project/home.dart';
import 'package:intl/intl.dart';

void main (){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
    ),
    home: LoginPage()
    );
  }
}

