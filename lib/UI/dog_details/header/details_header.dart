import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';
//import 'package:meta/meta.dart';

class DogDetailHeader extends StatefulWidget {
  final Dog dog;
  final Object avatarTag;

  const DogDetailHeader(
    this.dog, {
    super.key,
    required this.avatarTag,
  });

  @override
  DogDetailHeaderState createState() => DogDetailHeaderState();
}

class DogDetailHeaderState extends State<DogDetailHeader> {
  @override
  Widget build(BuildContext context) {
    //var theme = Theme.of(context);
    //var textTheme = theme.textTheme;

    var avatar = Hero(
      tag: widget.avatarTag,
      child: CircleAvatar(
        backgroundImage: NetworkImage(widget.dog.avatarUrl),
        radius: 75.0,
      ),
    );

    var likeInfo = Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.thumb_up,
            //color: Colors.white,
            size: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.dog.likeCounter.toString(),
              /*style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),*/
            ),
          )
        ],
      ),
    );

    var actionButtons = Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              minWidth: 140.0,
              color: Theme.of(context).colorScheme.secondary,
              //textColor: Colors.white,
              onPressed: () async {
                //TODO Handle Adopt
              },
              child: const Text('ADOPTAME'),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  //foregroundColor: Colors.white,
                  //backgroundColor: Colors.lightGreen,
                  ),
              onPressed: () async {
                //TODO Handle Like
              },
              child: const Text('ME GUSTA'),
            ),
          ),
        ],
      ),
    );

    return Stack(
      children: [
        Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: Column(
            children: [
              avatar,
              likeInfo,
              actionButtons,
            ],
          ),
        ),
        const Positioned(
          top: 26.0,
          left: 4.0,
          child: BackButton(/*color: Colors.white*/),
        ),
      ],
    );
  }
}
