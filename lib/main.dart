//import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/utils/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DogHero());
}

class DogHero extends StatelessWidget {
  const DogHero({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Ubuntu'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
