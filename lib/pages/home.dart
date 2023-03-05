import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:robanohashi/service/auth.dart';

import '../app_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    print("LOG USER EMAIL ${user?.email}}");

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (user == null) {
              Navigator.pushNamed(context, '/login');
            } else {
              await context.read<AuthService>().signOut();
            }
          },
          child: Text(user == null ? 'Sign in with email' : 'Sign out'),
        ),
      ),
    );
  }
}
