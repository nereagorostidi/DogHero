import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';

class DetailsShowcase extends StatelessWidget {
  final Dog dog;

  const DetailsShowcase(this.dog, {super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Center(
      child: Text(
        dog.description,
        textAlign: TextAlign.center,
        style: textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }
}
