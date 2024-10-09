import 'package:flutter/material.dart';
import 'package:src/screens/auth/register.dart';
import 'package:src/screens/auth/sign_in.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Register( ),
    );
  }
}