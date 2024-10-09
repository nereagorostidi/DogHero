import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:src/screens/auth/auth.dart';
import 'package:src/models/user.dart';
import 'package:src/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context); 
  
  if (user == null) {
    return Auth();
  } else {
    return Home();
    
  }
}
}