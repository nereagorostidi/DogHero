import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';

final dynamic dogattributeLookup = {
  "amigable": {"name": "amigable", "icon": FontAwesomeIcons.child},
  "castrado": {"name": "castrado", "icon": FontAwesomeIcons.scissors},
  "vacunado": {"name": "vacunado", "icon": FontAwesomeIcons.eyeDropper},
  "microchipeado": {
    "name": "microchipeado",
    "icon": FontAwesomeIcons.microchip
  },
  "fuerte": {"name": "fuerte", "icon": FontAwesomeIcons.microchip},
  "protector": {"name": "protector", "icon": FontAwesomeIcons.microchip},
  "leal": {"name": "leal", "icon": FontAwesomeIcons.microchip},
  "independiente": {
    "name": "independiente",
    "icon": FontAwesomeIcons.microchip
  },
  "jugueton": {"name": "jugueton", "icon": FontAwesomeIcons.microchip},
  "curioso": {"name": "curioso", "icon": FontAwesomeIcons.microchip},
  "valiente": {"name": "valiente", "icon": FontAwesomeIcons.microchip},
  "entrenado": {"name": "entrenado", "icon": FontAwesomeIcons.microchip},
  "energético": {"name": "energético", "icon": FontAwesomeIcons.microchip},
  "pequeño": {"name": "pequeño", "icon": FontAwesomeIcons.microchip},
  "mediano": {"name": "mediano", "icon": FontAwesomeIcons.microchip},
  "grande": {"name": "grande", "icon": FontAwesomeIcons.microchip},
};

class DogattributesShowcase extends StatelessWidget {
  final Dog dog;

  const DogattributesShowcase(this.dog, {super.key});

  _createCircleBadge(
      IconData iconData, Color bgColor, Color iconColor, String text) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: bgColor,
              radius: 36.0,
              child: Icon(
                iconData,
                color: iconColor,
                size: 36.0,
              ),
            ),
            Positioned(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];

    for (var i = 0; i < dog.dogattributes.length; i++) {
      var badge = _createCircleBadge(
        dogattributeLookup[dog.dogattributes[i]]['icon'],
        Colors.white12,
        Colors.white,
        dogattributeLookup[dog.dogattributes[i]]['name'],
      );

      items.add(badge);
    }

    var delegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );
    return GridView(
        padding: const EdgeInsets.only(top: 16.0),
        gridDelegate: delegate,
        children: items);
  }
}
