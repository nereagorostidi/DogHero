import 'package:doghero_app/UI/dog_details/details_body.dart';
import 'package:doghero_app/UI/dog_details/footer/details_footer.dart';
import 'package:doghero_app/UI/dog_details/header/details_header.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';

class DogDetailsPage extends StatefulWidget {
  //nueva pagina
  final Dog dog;
  final Object avatarTag;

  const DogDetailsPage(
    this.dog, {
    super.key,
    required this.avatarTag,
  });

  @override
  DogDetailsPageState createState() => DogDetailsPageState();
}

class DogDetailsPageState extends State<DogDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      //para aplicar un degradado como fondo
      gradient: LinearGradient(
        begin: FractionalOffset.centerRight, //punto inicio degradado
        end: FractionalOffset.bottomLeft, //punto final degradado
        colors: [
          Colors.orange,
          Colors.yellow,
        ],
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        //permite desplazar su contenido
        child: Container(
          decoration: linearGradient, //accedemos variable de degradado
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DogDetailHeader(
                widget.dog,
                avatarTag: widget.avatarTag,
              ),
              Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: DogDetailsBody(widget.dog)),
              DogShowcase(widget.dog),
            ],
          ),
        ),
      ),
    );
  }
}
