import 'package:doghero_app/models/dog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../../../services/db.dart';

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
  String username = "";
  String userPhone = "";
  String userSurName = "";
  String userEmail = "";
  String whyAdopt = ""; // Nueva variable para la razón de adopción
  String makeHappy = ""; // Nueva variable para cómo hará feliz al perro

  /// Envía un correo electrónico con los datos del adoptante
  void sendEmail() async {
    // Configuración del servidor SMTP
    String senderEmail = 'dog.heroadoption@gmail.com';
    String password = 'oqibxkdpleiqnjmk';

    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Obtiene los datos del usuario desde Firestore
      DatabaseService dbService = DatabaseService(uid: uid);
      String? name = await dbService.getUserName();
      int? phone = await dbService.getUserPhone();
      String? surName = await dbService.getUserSurname();
      String? email = await dbService.getUserEmail();
      String? reason = await dbService.getWhyAdopt(); // Obtiene la razón para adoptar
      String? happiness = await dbService.getMakeHappy(); // Obtiene cómo hará feliz al perro

      // Asigna los valores obtenidos a las variables
      setState(() {
        username = name ?? '';
        userPhone = phone != null ? phone.toString() : 'No proporcionado';
        userSurName = surName ?? '';
        userEmail = email ?? 'No proporcionado';
        whyAdopt = reason ?? 'No especificado';
        makeHappy = happiness ?? 'No especificado';
      });
    }

    // Configura el servidor SMTP
    final smtpServer = gmail(senderEmail, password);

    // Construye el mensaje del correo
    final message = Message()
      ..from = Address(senderEmail, 'DogHero') // Correo del remitente
      ..recipients.add(widget.dog.donationContactEmail) // Correo del donante
      ..subject = 'Solicitud de $username para adoptar a ${widget.dog.name}'
      ..html = '''
      
      <h3>IDENTIFICACION DEL PERRO A ADOPTAR Y DONANTE ASOCIADO</h3>
      <p>Email Donante: ${widget.dog.donationContactEmail}</p>
      <p>Nombre del Perro a adoptar:<strong> ${widget.dog.name} </strong></p>
      <p>DocID (Identificador): ${widget.dog.id}</p>

      <h3>DATOS DEL ADOPTANTE</h3>
      <p>Nombre: <strong>$username</strong></p>
      <p>Apellido:<strong>$userSurName</strong></p>
      <p><strong>Teléfono:</strong> $userPhone</p>
      <p><strong>Email de Contacto:</strong> $userEmail</p>

      <h3>MOTIVOS DEL DONANTE PARA ADOPTAR</h3>
      <p><strong>Razón para adoptar:</strong> $whyAdopt</p>
      <p><strong>Cómo intentará dar un hogar feliz y cuidados al perro:</strong> $makeHappy</p>
      ''';


    try {
      // Intenta enviar el correo
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
      await updateDogStatusToReserved(); // Actualiza el estado del perro
    } catch (e) {
      // Maneja errores en el envío del correo
      print('Error al enviar el correo: $e');
    }
  }

  /// Actualiza el estado del perro a "reservado"
  Future<void> updateDogStatusToReserved() async {
    try {
      DatabaseService dbService =
          DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid ?? "");
      bool success =
          await dbService.updateDogStatus(widget.dog.id, "reservated");
      if (success) {
        print('Dog status updated to reserved');
        setState(() {
          showButton = false; // Desactiva el botón de adopción
        });
      } else {
        print('Failed to update dog status');
      }
    } catch (e) {
      print('Error while updating dog status: $e');
    }
    print('showButton $showButton');
  }

  bool showButton = true;

  @override
  void initState() {
    // Define si se muestra el botón de adopción según el estado del perro
    showButton = widget.dog.status == "ready-to-adopt" ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            size: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.dog.likeCounter.toString(),
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
          widget.dog.status == "ready-to-adopt" && showButton == true
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    minWidth: 140.0,
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: sendEmail, // Llama a `sendEmail`
                    child: const Text('ADOPTAME'),
                  ),
                )
              : Container(),
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: ElevatedButton(
              onPressed: () async {
                // TODO: Maneja el "Me gusta"
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
          child: BackButton(),
        ),
      ],
    );
  }
}
