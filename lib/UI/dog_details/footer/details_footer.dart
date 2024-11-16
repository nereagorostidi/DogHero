import 'package:doghero_app/UI/dog_details/footer/showcase_dogattributes.dart';
import 'package:doghero_app/UI/dog_details/footer/showcase_details.dart';
import 'package:doghero_app/UI/dog_details/footer/showcase_pictures.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:flutter/material.dart';

class DogShowcase extends StatefulWidget {
  final Dog dog;

  const DogShowcase(this.dog, {super.key});

  @override
  DogShowcaseState createState() => DogShowcaseState();
}

class DogShowcaseState extends State<DogShowcase>
    with TickerProviderStateMixin {
  late List<Tab> _tabs;
  late List<Widget> _pages;
  late TabController _controller;

  @override
  initState() {
    super.initState();
    _tabs = [
      const Tab(text: 'FOTOS'),
      const Tab(text: 'DETALLES'),
      const Tab(text: 'CARACTERÍSTICAS'),
    ];
    _pages = [
      PicturesShowcase(widget.dog),
      DetailsShowcase(widget.dog),
      DogattributesShowcase(widget.dog),
    ];
    _controller = TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TabBar(
            controller: _controller,
            tabs: _tabs,
            //indicatorColor: Colors.white,
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
