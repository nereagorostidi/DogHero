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
import 'package:firebase_messaging/firebase_messaging.dart'; // Import necesario para el FCM token

class Preferencias extends StatefulWidget {
  const Preferencias({super.key});

  @override
  State<Preferencias> createState() => _PreferenciasState();
}

class _PreferenciasState extends State<Preferencias> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Variables para almacenar los datos del formulario
  String _name = '';
  String _surname = ''; // Nuevo: Apellido
  String _location = '';
  int _number = 0;
  String _whyAdopt = ''; // Nuevo: ¿Por qué quieres adoptar?
  String _makeHappy = ''; // Nuevo: ¿Cómo harás feliz al perro?
  String? _fcmToken; // Token FCM del dispositivo

  @override
  void initState() {
    super.initState();
    _getFcmToken(); // Obtiene el FCM token al cargar la pantalla
  }

  // Método para obtener el FCM token
  Future<void> _getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    setState(() {
      _fcmToken = token;
    });
    print("FCM Token: $_fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: _auth.user, // Proporciona el usuario autenticado
      initialData: null,
      child: Consumer<User?>(
        builder: (context, user, _) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: const Text('DogHero - Datos Personales'),
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
                        'Modifica tus Datos Personales, estos serán usados para rellenar los formularios de adopción',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            // Campo: Nombre
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
                            // Campo: Apellido
                            TextFormField(
                              decoration: textFieldDecoration.copyWith(
                                hintText: 'Apellido',
                                suffixIcon: const Icon(Icons.person_outline),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Introduce un apellido' : null,
                              onChanged: (val) {
                                setState(() => _surname = val);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            // Campo: Ubicación
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
                            // Campo: Teléfono
                            TextFormField(
                              decoration: textFieldDecoration.copyWith(
                                hintText: 'Número de Teléfono',
                                suffixIcon: const Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (val) => val!.isEmpty
                                  ? 'Introduce un número de teléfono'
                                  : null,
                              onChanged: (val) {
                                setState(() => _number = int.tryParse(val) ?? 0);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            // Campo: ¿Por qué quieres adoptar?
                            TextFormField(
                              decoration: textFieldDecoration.copyWith(
                                hintText: '¿Por qué quieres adoptar un perro?',
                                suffixIcon: const Icon(Icons.question_answer),
                              ),
                              maxLines: 3,
                              validator: (val) => val!.isEmpty
                                  ? 'Por favor, responde esta pregunta'
                                  : null,
                              onChanged: (val) {
                                setState(() => _whyAdopt = val);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            // Campo: ¿Cómo harás feliz al perro?
                            TextFormField(
                              decoration: textFieldDecoration.copyWith(
                                hintText:
                                    'Explica cómo harás feliz al perro',
                                suffixIcon: const Icon(Icons.sentiment_satisfied),
                              ),
                              maxLines: 3,
                              validator: (val) => val!.isEmpty
                                  ? 'Por favor, responde esta pregunta'
                                  : null,
                              onChanged: (val) {
                                setState(() => _makeHappy = val);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            // Botón para guardar los datos
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              child: const Text('Guardar'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await DatabaseService(uid: user!.uid)
                                      .updateUserData(
                                    name: _name,
                                    surname: _surname,
                                    location: _location,
                                    phone: _number,
                                    whyAdopt: _whyAdopt,
                                    makeHappy: _makeHappy,
                                    fcmToken: _fcmToken,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Datos guardados correctamente')),
                                  );
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
