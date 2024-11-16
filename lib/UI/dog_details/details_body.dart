import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';

class DogDetailsBody extends StatelessWidget {
  final Dog dog;

  const DogDetailsBody(this.dog, {super.key});

  _createCircleBadge(IconData iconData, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 16.0,
        child: Icon(
          iconData,
          //color: Colors.white,
          size: 16.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var locationInfo = Row(
      children: [
        const Icon(
          Icons.place,
          //color: Colors.white,
          size: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            dog.location,
            style: textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dog.name,
          //style: textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: locationInfo,
        ),
        // Badges
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            dog.description,
            //style: textTheme.bodyMedium?.copyWith(color: Colors.white70, fontSize: 16.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              _createCircleBadge(Icons.share, theme.colorScheme.primary),
              _createCircleBadge(Icons.phone, Colors.white12),
              _createCircleBadge(Icons.email, Colors.white12),
            ],
          ),
        ),
      ],
    );
  }
}
