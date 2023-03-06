import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:robanohashi/service/auth.dart';

import '../app_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String> token;
  @override
  void initState() {
    super.initState();
    final user = context.read<User?>();
    token = user?.getIdToken() ?? Future.value('');
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          FutureBuilder(
            future: token,
            builder: (context, snapshot) {
              if (ConnectionState.done == snapshot.connectionState)
                return SelectableText(snapshot.data.toString());
              else
                return Text('Loading token...');
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (user == null) {
                Navigator.pushNamed(context, '/login');
              } else {
                await context.read<AuthService>().signOut();
              }
            },
            child: Column(
              children: [
                Text(user == null ? 'Sign in with email' : 'Sign out'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
