# Estructura del proyecto

En lib tenemos todos los .darts en donde se esta trabjando, dentro de este directorio tenemos:
- [Models](lib\models): en este encontraremos los "planos" de las clases especificas que creemos, por ahora tenemos un user.dart que es el user con los datos que nos interesa (por ahora uid), cuando creemos a los perros, deberiamos de crear una clase aqui para ellos.
- [Screens](lib/screens/): aca encontraremos las pantallas de la app
- [Services](lib/services/): aca estan los metodos que utilizaremos en la app, lo podemos ver como las funciones del backend.
- [Shared](lib/shared/): aca guardaremos presets los cuales ocuparemos en varias pantallas, con esto nos ahorramos escribir en todas las pantallas el mismo codigo, util para cuando veamos todo el tema del diseno como tal.

## Auth
El auth funciona basicamente con un wrapper el cual esta escuchando cuando se inicia la app, si el user esta registrado se lleva al sign in, en caso contrario se lleva al registro, todo esta conectado con firebase para la autenticacion como tal.
Cuando se logea el usuario, se le lleva a home


