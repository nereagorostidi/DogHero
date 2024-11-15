import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/test.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:doghero_app/services/db.dart';
import 'package:provider/provider.dart';
import 'package:doghero_app/utils/constants.dart';
import 'package:doghero_app/models/user.dart';

class Preferencias extends StatefulWidget {
  const Preferencias({super.key});

  @override
  State<Preferencias> createState() => _PreferenciasState();
}

class _PreferenciasState extends State<Preferencias> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _number = 0;
  String _location = '';
  final int _prefDogSize = 0;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: _auth.user,
      initialData: null,
      child: Consumer<User?>(
        builder: (context, user, _) {
          return Scaffold(
            //backgroundColor: Colors.orange,
            appBar: AppBar(
              //backgroundColor: const Color.fromARGB(255, 87, 88, 88),
              elevation: 0.0,
              title: const Text('DogHero- Datos Personales'),
            ),
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Modifica tus Datos Personales, estos seran usados para rellenar los formularios de adopción',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          //color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: textFieldDecoration.copyWith(
                                hintText: 'Nombre',
                                suffixIcon: const Icon(Icons.person),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Introduce un nombre' : null,
                              onChanged: (val) {
                                setState(() => _name = val);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textFieldDecoration.copyWith(
                                hintText: 'Ubicación',
                                suffixIcon: const Icon(Icons.location_on),
                              ),
                              validator: (val) => val!.isEmpty
                                  ? 'Introduce una ubicación'
                                  : null,
                              onChanged: (val) {
                                setState(() => _location = val);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textFieldDecoration.copyWith(
                                hintText: 'Numero de Telefono',
                                suffixIcon: const Icon(Icons.phone),
                              ),
                              validator: (val) => val!.isEmpty
                                  ? 'Introduce un numero de telefono'
                                  : null,
                              onChanged: (val) {
                                setState(
                                    () => _number = int.tryParse(val) ?? 0);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              child: const Text(
                                'Guardar',
                                //style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await DatabaseService(uid: user!.uid)
                                      .updateUserData(
                                          _name, _number, _location);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
