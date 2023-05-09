import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robanohashi/common/future_wrapper.dart';
import 'package:robanohashi/common/mnemonic/user_mnemonics.dart';
import 'package:robanohashi/common/subject_preview_card.dart';
import 'package:robanohashi/service/bookmarks.dart';

class UserView extends StatelessWidget {
  const UserView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              ),
              Tab(
                child: Text('Bookmarked'),
              )
            ]),
            const Expanded(
              child: TabBarView(children: [
                MnemonicsListByUser(),
                MnemonicsListByUser(favorites: true),
                BookmarkedSubjects()
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class BookmarkedSubjects extends StatefulWidget {
  const BookmarkedSubjects({super.key});

  @override
  State<BookmarkedSubjects> createState() => _BookmarkedSubjectsState();
}

class _BookmarkedSubjectsState extends State<BookmarkedSubjects> {
  @override
  void initState() {
    super.initState();

    final user = context.read<User>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkedSubjectsService>().fetchBookmarkedSubjects(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<BookmarkedSubjectsService>().subjects;
    return FutureWrapper(
        future: subjects,
        onData: (context, data) {
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return SubjectPreviewCard(
                  subject: data[index],
                );
              });
        });
  }
}
