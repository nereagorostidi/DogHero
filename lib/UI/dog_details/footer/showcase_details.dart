import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';

class DetailsShowcase extends StatelessWidget {
  final Dog dog;

  const DetailsShowcase(this.dog, {super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10.0,
        ),
        Text(
          dog.sex,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          dog.color,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          dog.breed,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}