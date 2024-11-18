import 'package:doghero_app/UI/auth/auth.dart';
import 'package:doghero_app/UI/cuidadora/home_cuidadora.dart';
import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/home.dart';
import 'package:doghero_app/UI/auth/login.dart';
import 'package:doghero_app/UI/auth/register.dart';
import 'package:doghero_app/UI/test.dart';
import 'package:doghero_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const Auth();
    }

    // Return FutureBuilder to handle the async Firebase check
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        // Show loading spinner while checking role
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle errors
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Check if document exists and has role field
        if (snapshot.hasData && snapshot.data!.exists) {
          Map<String, dynamic> userData = 
              snapshot.data!.data() as Map<String, dynamic>;
          
          if (userData['role'] == 'protectora') {
            return CuidadoraHome();
          }
        }

        // Default case or if role != 'protectora'
        return Test();
      },
    );
  }
}