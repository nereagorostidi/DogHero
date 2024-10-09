import 'package:flutter/material.dart';
import 'package:src/services/auth.dart';
import 'package:src/shared/constants.dart';

class Register extends StatefulWidget {

  final Function toggle;

  const Register({super.key, required this.toggle});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200], //placeholder this need to be changed to our color palette
      appBar: AppBar(
        backgroundColor: Colors.teal[800], //placeholder this need to be changed to our color palette
        elevation: 0.0,
        title: const Text('Registrate en DogHero'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              widget.toggle();
            },
            icon: const Icon(Icons.person),
            label: const Text('Ingresar'),
            
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formkey,
          child: Column(
          children: [
            const SizedBox(height: 20.0),
            TextFormField(
              validator: (value) => value!.isEmpty ? 'Ingresa tu email' : null,
              onChanged: (val){
                setState(() => email = val);
              },
              decoration: textFieldDecoration.copyWith(
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              validator: (value) => value!.length < 6 ? 'Tu password debe tener mas de 6 caracteres' : null,
              onChanged: (val){
                setState(() => password = val);
              },
              decoration: textFieldDecoration.copyWith(
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()){
                  dynamic res = await _auth.register(email, password);
                  if (res == null){
                    setState( () => error = 'Verifica tus datos e intenta denuevo');
                  }
                }
              },
              child: const Text('Registrate'),
            ),
            SizedBox(height: 20,),
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            )
          ],
        )
        )
      ),
    );
  }
}