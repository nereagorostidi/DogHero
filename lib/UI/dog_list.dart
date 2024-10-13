import 'dart:async';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:doghero_app/services/api.dart';
import 'package:doghero_app/utils/routes.dart';
import 'package:doghero_app/UI/dog_details/details_page.dart';
import 'package:flutter/material.dart';

class DogList extends StatefulWidget {
  const DogList({super.key});

  @override
  State<DogList> createState() => _DogListState();
}

class _DogListState extends State<DogList> {
  //estado mutable
  List<Dog> _dogs =
      []; // lista que se llenará cuando se carguen los datos desde JSON.
  //late DogApi? _api;
  //late NetworkImage _profileImage;

  _loadDogs() async {
    //asincrono por que es una operación que puede tardar un tiempo indeterminado en completarse
    /*String fileData = await DefaultAssetBundle.of(context).loadString(
        "assets/dogs.json"); //permite acceder a los recursos o assets incluidos en el proyecto
    setState(() {
      _dogs = DogApi.allDogsFromJson(
          fileData); //almacenas la información de cada gato en la lista
    });*/

    try {
      List<Dog> dogs = await DogApi.allDogsFromFirestore();
      setState(() {
        _dogs = dogs;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /*_loadFromFirebase() async {
    final api = await DogApi
        .signInWithGoogle(); //devuelve CatApi que contiene información sobre el usuario autenticado.
    setState(() {
      _api = api; //Asigna el valor obtenido de signInWithGoogle()
      _profileImage = NetworkImage(api?.firebaseUser?.photoURL ?? "");
    });
  }*/

  @override
  void initState() {
    super.initState();
    _loadDogs();
    //_loadFromFirebase();
  }

  Widget _buildDogItem(BuildContext context, int index) {
    Dog dog = _dogs[index];
    return Container(
      margin: const EdgeInsets.only(
          top: 5.0), // añade espacio alrededor del Container
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // la columna solo ocupará el espacio necesario para mostrar su contenido.
          children: [
            ListTile(
              //representa una fila que puede ser interactiva
              onTap: () => _navigateToDogDetails(dog, index),
              leading: Hero(
                //widget que permite animaciones entre pantallas
                tag: index, //debe ser unico
                child: CircleAvatar(
                  backgroundImage: NetworkImage(dog.avatarUrl),
                ),
              ),
              title: Text(dog.name,
                  style: const TextStyle(
                    fontWeight: FontWeight
                        .bold, //grosor del texto, en este caso negrita
                    color: Colors.black,
                  )),
              subtitle: Text(dog.description),
              isThreeLine:
                  true, //ajustar texto para mostrar tres lineas de texto
              dense: false, //permite un mayor espacio entre los elementos
            )
          ],
        ),
      ),
    );
  }

  void _navigateToDogDetails(Dog dog, Object avatarTag) {
    // método para navegar a otra pagina
    Navigator.of(context).push(FadePageRoute(
        builder: (c) {
          //construye el widget que se mostrará en nueva ruta
          return DogDetailsPage(dog,
              avatarTag:
                  avatarTag); // definimos lo que se mostrará en nueva pagina
        },
        settings: const RouteSettings())); //proporciona información adicional
  }

  Widget _getAppTittleWidget() {
    return const Text(
      'Lista de perros',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32.0),
    );
  }

  Future<void> refresh() {
    _loadDogs();
    return Future<void>.value(); //la operacion se ha completado
  }

  Widget _getListViewWidget() {
    return Flexible(
        //permite que su hijo (el ListView) se ajuste y ocupe el espacio disponible dentro de su padre
        child: RefreshIndicator(
            //proporciona la funcionalidad de "pull to refresh" (deslizar hacia abajo para refrescar) en el ListView
            onRefresh: refresh,
            child: ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(), //la lista siempre se puede desplazar
              //siempre podremos hacer "pull to refresh"
              itemCount: _dogs.length,
              itemBuilder: _buildDogItem,
            )));
  }

  Widget _buildBody() {
    return Container(
        margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 0.0),
        child: Column(
          children: [_getAppTittleWidget(), _getListViewWidget()],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: _buildBody(),
      /*floatingActionButton: _isLoading
            ? null // No muestra el botón mientras carga
            : FloatingActionButton(
                onPressed: () {},
                tooltip: _api != null
                    ? 'Signed in: ${_api?.firebaseUser?.displayName}'
                    : 'Not signed-in',
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  backgroundImage: _profileImage,
                  radius: 50.0,
                ))*/
    );
  }
}
