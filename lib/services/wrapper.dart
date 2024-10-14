import 'package:doghero_app/UI/auth/auth.dart';
import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/home.dart';
import 'package:doghero_app/UI/auth/login.dart';
import 'package:doghero_app/UI/auth/register.dart';
import 'package:doghero_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    if (user == null){
      return Auth();
    } else{
      return Home();
    }
  }
}