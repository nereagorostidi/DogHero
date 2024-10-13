import 'package:flutter/material.dart';

//Cuando navegamos una nueva página utilizando FadePageRoute, veremos que la nueva pantalla aparece gradualmente

class FadePageRoute<T> extends MaterialPageRoute<T> {
  //heredamos las funcionalidades de MaterialPageRoute
  FadePageRoute(
      {required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      //verifica si el nombre de la ruta es la raíz de la aplicación
      return child; //no animación
    }

    return FadeTransition(opacity: animation, child: child); //hacemos animacion
  }
}
