import 'package:doghero_app/UI/auth/login.dart';
import 'package:doghero_app/UI/auth/register.dart';
import 'package:flutter/material.dart';


class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool registered = false;

  void toggleRegistered() {
    setState(() => registered = !registered);
  }
  @override
  Widget build(BuildContext context) {
    if (registered){
      return Login(toggleRegistered: toggleRegistered);
    } else{
      return Register(toggleRegistered: toggleRegistered);
    }
  }
}