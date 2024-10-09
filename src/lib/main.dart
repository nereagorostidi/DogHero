import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:src/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:src/services/auth.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}



