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

  void sendEmail() async {
    // SMTP server configuration
    String senderEmail = 'europesip@gmail.com';
    String password = 'ogckfkcpohdbpdke';
    String username = "";
    String userPhone = "";
    String userSurName = "";
    String userEmail = "";
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DatabaseService dbService = DatabaseService(uid: uid);
      String? name = await dbService.getUserName();
      int? phone = await dbService.getUserPhone();
      String? surName = await dbService.getUserSurname();
      String? email = await dbService.getUserEmail();
      setState(() {
        username = name ?? '';
        userPhone = phone.toString();
        userSurName = surName.toString();
        userEmail = email.toString();
      });
    }
    final smtpServer = gmail(senderEmail, password);

    final message = Message()
      ..from = Address(senderEmail, 'europesip')
      ..recipients.add(widget.dog.donationContactEmail)
      ..subject = 'Addopt Dogs'
      ..text = 'Email : ${widget.dog.donationContactEmail}\nDOCUID: ${widget.dog.id}\nName: $username\nLastname: $userSurName\nUserEmail: $userEmail';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
      await updateDogStatusToReserved();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateDogStatusToReserved() async {
    try {
      DatabaseService dbService = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid ?? "");
      bool success = await dbService.updateDogStatus(widget.dog.id, "reservated");
      if (success) {
        print('Dog status updated to reserved');
        setState(() {
          showButton = false;
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
    // TODO: implement initState
    showButton = widget.dog.status == "ready-to-adopt" ? true : false;
    super.initState();
  }

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
            color: Colors.white,
            size: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.dog.likeCounter.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
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
          widget.dog.status == "ready-to-adopt" && showButton == true ? ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              minWidth: 140.0,
              color: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
              onPressed: () async {
                //TODO Handle Adopt
                sendEmail();
              },
              child: const Text('ADOPTAME'),
            ),
          ) : Container(),
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen,
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
          child: BackButton(color: Colors.white),
        ),
      ],
    );
  }
}
