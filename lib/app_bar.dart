import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'search/search_delegate.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    return AppBar(
      title: const Text(
        "Roba no hashi",
      ),
      actions: [
        user != null
            ? IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/user', (route) => false);
                },
                icon: const Icon(Icons.person))
            : Container(),
        IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: const Icon(Icons.home)),
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: DictionarySearchDelegate());
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
