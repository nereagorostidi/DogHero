import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';

final dynamic dogattributeLookup = {
  "children": {"name": "Kid Friendly", "icon": FontAwesomeIcons.child},
  "desexed": {"name": "Desexed", "icon": FontAwesomeIcons.scissors},
  "vaccinated": {"name": "Vaccinated", "icon": FontAwesomeIcons.eyeDropper},
  "microchipped": {"name": "Microchipped", "icon": FontAwesomeIcons.microchip},
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
