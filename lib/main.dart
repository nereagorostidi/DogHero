import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/auth/login.dart';
import 'package:doghero_app/models/user.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:doghero_app/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DogHero());
}

class DogHero extends StatelessWidget {
  const DogHero({super.key});
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Ubuntu', useMaterial3: false),
      home: Login(),
    );
  }
}
*/
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Ubuntu', useMaterial3: false),
        home: Wrapper(),
      )
    );
  }
}