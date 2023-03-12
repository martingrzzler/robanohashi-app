import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:robanohashi/common/future_wrapper.dart';
import 'package:robanohashi/common/mnemonic/mnemonic_view.dart';

import 'package:flutter/material.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/meaning_mnemonic.dart';

import 'form.dart';

class MnemonicsListByUser extends StatefulWidget {
  const MnemonicsListByUser({super.key, this.favorites = false});

  final bool favorites;

  @override
  State<MnemonicsListByUser> createState() => _MnemonicsListByUserState();
}

class _MnemonicsListByUserState extends State<MnemonicsListByUser> {
  late Future<List<MeaningMnemonicWithUserInfo>> _mnemonics;
  FormConfig _formConfig = FormConfig(editing: false);

  @override
  void initState() {
    super.initState();
    final user = context.read<User?>()!;
    _mnemonics = widget.favorites
        ? Api.fetchMeaningMnemonicsFavorites(user)
        : Api.fetchMeaningMnemonicsByUser(user);
  }

  void refetchMnemonics() {
    final user = context.read<User?>()!;
    setState(() {
      _mnemonics = widget.favorites
          ? Api.fetchMeaningMnemonicsFavorites(user)
          : Api.fetchMeaningMnemonicsByUser(user);
    });
  }

  void handleOnUpvote(MeaningMnemonicWithUserInfo mnemonic) {
    return updateMnemonic(
        (user) async => await Api.voteMeaningMnemonic(1, mnemonic.id, user),
        'Failed to upvote mnemonic');
  }

  void handleOnDonwvote(MeaningMnemonicWithUserInfo mnemonic) {
    return updateMnemonic(
        (user) async => await Api.voteMeaningMnemonic(-1, mnemonic.id, user),
        'Failed to downvote mnemonic');
  }

  void handleToggleFavorite(MeaningMnemonicWithUserInfo mnemonic) {
    return updateMnemonic(
        (user) async =>
            await Api.toggleMeaningMnemonicFavorite(mnemonic.id, user),
        'Failed to toggle favorite');
  }

  void handleOnDelete(MeaningMnemonicWithUserInfo mnemonic) {
    return updateMnemonic(
        (user) async => await Api.deleteMeaningMnemonic(mnemonic.id, user),
        'Failed to delete mnemonic');
  }

  void updateMnemonic(Function(User) onUpdate, String failureMessage) async {
    final user = context.read<User?>();

    assert(user != null);

    try {
      await onUpdate(user!);
      refetchMnemonics();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage),
        ),
      );
    }
  }

  void handleOnFormSubmit(String text) async {
    final mnemonic = _formConfig.mnemonic!;
    setState(() {
      _formConfig = FormConfig(editing: false);
    });

    final user = context.read<User?>();
    assert(user != null);

    try {
      await Api.updateMeaningMnemonic(mnemonic.id, user!, text);
      refetchMnemonics();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create mnemonic'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: _mnemonics,
      onData: (context, data) {
        if (_formConfig.editing) {
          return MnemonicForm(
            onClose: () {
              setState(() {
                _formConfig = FormConfig(editing: false);
              });
            },
            onSubmit: (text) => handleOnFormSubmit(text),
            defaultText: _formConfig.mnemonic!.text,
          );
        }

        if (data.isEmpty) {
          return const Center(
            child: Text('No mnemonics yet'),
          );
        }

        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final mnemonic = data[index];

              return MnemonicView(
                  mnemonic: mnemonic,
                  onOnUpvote: handleOnUpvote,
                  onOnDonwvote: handleOnDonwvote,
                  linkToSubject: true,
                  onToggleFavorite: handleToggleFavorite,
                  onDelete: (mnemonic) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text(
                                  'The mnemonic will be deleted permanently.'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel')),
                                OutlinedButton(
                                  onPressed: () {
                                    handleOnDelete(mnemonic);
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.red[200]!, width: 2)),
                                  child: Text('Delete',
                                      style: TextStyle(color: Colors.red[200])),
                                )
                              ],
                            ));
                  },
                  onEdit: (mnemonic) {
                    setState(() {
                      _formConfig =
                          FormConfig(editing: true, mnemonic: mnemonic);
                    });
                  });
            });
      },
    );
  }
}
