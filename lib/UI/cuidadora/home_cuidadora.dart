import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/UI/cuidadora/dogs_cuidadora.dart';
import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/test.dart';
import 'package:doghero_app/main.dart';
import 'package:doghero_app/models/user.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:doghero_app/utils/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:doghero_app/services/db.dart';
import 'package:provider/provider.dart';
import 'package:doghero_app/UI/preferencias.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doghero_app/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class CuidadoraHome extends StatefulWidget {
  CuidadoraHome({super.key});

  @override
  State<CuidadoraHome> createState() => _CuidadoraHomeState();
}

class _CuidadoraHomeState extends State<CuidadoraHome> {
  final AuthService _auth = AuthService();
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final _formkey = GlobalKey<FormState>();
  int _age = 0;
  String _name = '';
  String _color = '';
  String _description = '';
  String _energyLevel = '';
  String _sex = 'Macho'; 
  String _size = '';
  List<String> _images = [];
  String _location = '';
  
  File? _imageFile;
  String _imageUrl = '';
  final ImagePicker _picker = ImagePicker();

  // Image upload function
  Future<void> _uploadImage(File image) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
      
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('dog_images')
          .child(fileName);

      await ref.putFile(image);
      String downloadUrl = await ref.getDownloadURL();
      
      setState(() {
        _imageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  // Image picker function
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _uploadImage(_imageFile!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Image picker widget
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto del perro',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.photo_camera),
              label: Text('Cámara'),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text('Galería'),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        if (_imageFile != null) ...[
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override

  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: _auth.user,
      initialData: null,
      child: Consumer<User?>(
        builder: (context, user, _) {
          return StreamProvider<QuerySnapshot?>.value(
            value: user != null ? DatabaseService(uid: user.uid).users : null,
            initialData: null,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 87, 88, 88),
                  elevation: 0.0,
                  title: const Text('DogHero'),
                  actions: <Widget>[
                    PopupMenuButton<String>(
                      onSelected: (String result) async {
                        if (result == 'Salir') {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          await _auth.signOut();
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SplashScreen()),
                        );
                        } else if (result == 'Preferencias') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Preferencias()),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Preferencias',
                          child: Text('Preferencias'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Salir',
                          child: Text('Salir'),
                        ),
                      ],
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Form(
                                  key: _formkey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          decoration: textFieldDecoration.copyWith(
                                            hintText: 'Nombre',
                                            suffixIcon: Icon(Icons.pets),
                                          ),
                                          validator: (value) => value!.isEmpty ? 'Nombre' : null,
                                          onChanged: (value) {
                                            setState(() => _name = value);
                                          },
                                        ),
                                        SizedBox(height: 16.0),
                                        TextFormField(
                                          decoration: textFieldDecoration.copyWith(
                                            hintText: 'Edad',
                                            suffixIcon: Icon(Icons.cake),
                                          ),
                                          validator: (value) => value!.isEmpty ? 'Edad' : null,
                                          onChanged: (value) {
                                            setState(() => _age = int.tryParse(value)!);
                                          },
                                        ),
                                        SizedBox(height: 16.0),
                                        TextFormField(
                                          decoration: textFieldDecoration.copyWith(
                                            hintText: 'Color',
                                            suffixIcon: Icon(Icons.color_lens),
                                          ),
                                          validator: (value) => value!.isEmpty ? 'Color' : null,
                                          onChanged: (value) {
                                            setState(() => _color = value);
                                          },
                                        ),
                                        SizedBox(height: 16.0),
                                        TextFormField(
                                          decoration: textFieldDecoration.copyWith(
                                            hintText: 'Descripcion',
                                            suffixIcon: Icon(Icons.description),
                                          ),
                                          validator: (value) => value!.isEmpty ? 'Descripcion' : null,
                                          onChanged: (value) {
                                            setState(() => _description = value);
                                          },
                                        ),
                                        SizedBox(height: 16.0),
                                        DropdownButtonFormField<String>(
                                          decoration: textFieldDecoration.copyWith(
                                          hintText: 'Sexo',
                                          suffixIcon: Icon(Icons.transgender),
                                          ),
                                          value: _sex.isEmpty ? null : (_sex == 'Macho' ? 'Macho' : 'Hembra'),
                                          items: ['Macho', 'Hembra'].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                          }).toList(),
                                          validator: (value) => value == null ? 'Enter a sex' : null,
                                          onChanged: (value) {
                                          setState(() {
                                            _sex = value == 'Macho' ? 'male' : 'female';
                                          });
                                          },
                                        ),
                                        SizedBox(height: 16.0),
                                        DropdownButtonFormField<String>(
                                          decoration: textFieldDecoration.copyWith(
                                            hintText: 'Tamano',
                                            suffixIcon: Icon(Icons.straighten),
                                          ),
                                          value: _size.isEmpty ? null : (_size == 'small' ? 'Pequeno' : (_size == 'medium' ? 'Mediano' : 'Grande')),
                                          items: ['Pequeno', 'Mediano', 'Grande'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          validator: (value) => value == null ? 'Enter a size' : null,
                                          onChanged: (value) {
                                            setState(() {
                                              if(value == 'Pequeno') {
                                                _size = 'small';
                                              } else if(value == 'Mediano') {
                                                _size = 'medium';
                                              } else {
                                                _size = 'large';
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(height: 16.0),
                                        // Add the image picker here
                                        _buildImagePicker(),
                                        SizedBox(height: 16.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Atributos',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: [
                                                for (var attribute in [
                                                  {"name": "amigable", "icon": FontAwesomeIcons.child},
                                                  {"name": "castrado", "icon": FontAwesomeIcons.scissors},
                                                  {"name": "vacunado", "icon": FontAwesomeIcons.eyeDropper},
                                                  {"name": "microchipeado", "icon": FontAwesomeIcons.microchip},
                                                  {"name": "fuerte", "icon": FontAwesomeIcons.ethereum},
                                                  {"name": "protector", "icon": FontAwesomeIcons.shield},
                                                  {"name": "leal", "icon": FontAwesomeIcons.star},
                                                  {"name": "independiente", "icon": FontAwesomeIcons.microchip},
                                                  {"name": "jugueton", "icon": FontAwesomeIcons.tableTennisPaddleBall},
                                                  {"name": "curioso", "icon": FontAwesomeIcons.eye},
                                                  {"name": "valiente", "icon": FontAwesomeIcons.khanda},
                                                  {"name": "entrenado", "icon": FontAwesomeIcons.dumbbell},
                                                  {"name": "energético", "icon": FontAwesomeIcons.bolt},
                                                ])
                                                  FilterChip(
                                                    label: Text(attribute["name"] as String),
                                                    avatar: Icon(attribute["icon"] as IconData),
                                                    selected: _images.contains(attribute["name"]),
                                                    onSelected: (bool selected) {
                                                      setState(() {
                                                        if (selected) {
                                                          _images.add(attribute["name"] as String);
                                                        } else {
                                                          _images.remove(attribute["name"]);
                                                        }
                                                      });
                                                    },
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16.0),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_formkey.currentState!.validate()) {
                                              final dogData = {
                                                'name': _name,
                                                'age': _age,
                                                'color': _color,
                                                'description': _description,
                                                'sex': _sex,
                                                'size': _size,
                                                'attributes': _images,
                                                'imageUrl': _imageUrl,
                                                'userId': user!.uid,
                                                'timestamp': FieldValue.serverTimestamp(),
                                              };
                                              _location = (await DatabaseService(uid: user.uid).getUserLocation())!;
                                              DatabaseService(uid: user.uid).createDog(
                                                name: _name,
                                                age: _age,
                                                color: _color,
                                                description: _description,
                                                sex: _sex,
                                                size: _size,
                                                attributes: _images,
                                                imageUrl: _imageUrl,
                                                userId: user.uid,
                                                location: _location,
                                                );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Perro subido con exito')),
                                              );
                                            }
                                          },
                                          child: const Text('Subir perro'),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                       CurvedNavigationBar(
                        key: _bottomNavigationKey,
                        index: _page,
                        animationDuration: const Duration(milliseconds: 200),
                        backgroundColor: const Color.fromARGB(255, 87, 88, 88),
                        height: 50.0,
                        items: const <Widget>[
                          Icon(Icons.upload, size: 30, color: Colors.black45),
                          Icon(Icons.list, size: 30, color: Colors.black45),
                        ],
                        onTap: (index) {
                          setState(() {
                            _page = index;
                            if (index == 1) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => DogsCuidadora()),
                              );
                            } else if (index == 0) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => CuidadoraHome()),
                              );
                            }
                          });
                        },
                        letIndexChange: (value) => true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}