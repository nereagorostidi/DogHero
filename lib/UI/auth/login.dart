import 'package:doghero_app/UI/auth/register.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:doghero_app/utils/constants.dart';
import 'package:doghero_app/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Login extends StatefulWidget {
  final Function toggleRegistered;
  const Login({Key? key, required this.toggleRegistered}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String error = '';

  final Resource _response = Init();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  //color: Colors.orange,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "DogHero",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 50.0,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        const Image(
                          image: AssetImage('assets/images/logo_nuevo.png'),
                          height: 150,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: const Text(
                    "Ingresa a DogHero",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        decoration: textFieldDecoration.copyWith(
                          hintText: 'Email',
                          suffixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (val) => val!.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        decoration: textFieldDecoration.copyWith(
                          hintText: 'Password',
                          suffixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              dynamic res = await _auth.signIn(email, password);
                              if (res == null) {
                                setState(() => error =
                                    'Verifica tus credenciales y intenta de nuevo');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.toggleRegistered();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('No tienes cuenta?, Registrate'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
