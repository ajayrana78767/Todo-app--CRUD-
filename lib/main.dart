import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_list.dart';
//import 'package:todo_app/screens/todo_list.dart';

//import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData.dark(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LodoListPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // You can customize the splash screen widget here
    return const Scaffold(
      backgroundColor: Colors.black, // Set the background color
      body: Center(
        child: Text("Welcome to todo app",style: TextStyle(fontSize: 30),),
        // child: Image.asset('assets/splash_screen/splash.png'), // Set the image path
      ),
    );
  }
}
