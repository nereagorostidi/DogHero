import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';

class PicturesShowcase extends StatelessWidget {
  final Dog dog;

  const PicturesShowcase(this.dog, {super.key});

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];

    for (var i = 0; i < dog.pictures.length; i++) {
      var image = Image.network(
        dog.pictures[i],
        width: 200.0,
        height: 200.0,
      );
      items.add(image);
    }
    var delegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );
    return GridView(
      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children: items,
    );
  }
}
