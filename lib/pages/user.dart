import 'package:flutter/material.dart';
import 'package:robanohashi/common/mnemonic/user_mnemonics.dart';

class UserView extends StatelessWidget {
  const UserView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: const Text('Profile'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const TabBar(tabs: [
              Tab(
                child: Text('Mnemonics'),
              ),
              Tab(
                child: Text('Favorites'),
              )
            ]),
            const Expanded(
              child: TabBarView(children: [
                MnemonicsListByUser(),
                MnemonicsListByUser(favorites: true)
              ]),
            )
          ],
        ),
      ),
    );
  }
}
