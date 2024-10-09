import 'package:flutter/material.dart';
import 'package:src/services/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200], //placeholder this need to be changed to our color palette
      appBar: AppBar(
        backgroundColor: Colors.teal[800], //placeholder this need to be changed to our color palette
        elevation: 0.0,
        title: const Text('Registrate en DogHero'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(child: Column(
          children: [
            const SizedBox(height: 20.0),
            TextFormField(
              onChanged: (val){
                setState(() => email = val);
              },
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              onChanged: (val){
                setState(() => password = val);
              },
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                print(email);
                print(password);
                //sign in
              },
              child: const Text('Registrate'),
            ),
          ],
        )
        )
      ),
    );
  }
}