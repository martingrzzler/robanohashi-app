import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:robanohashi/api/common.dart';
import 'package:robanohashi/common/future_wrapper.dart';
import 'package:robanohashi/common/mnemonic/mnemonic_view.dart';
import 'package:robanohashi/common/mnemonic/tagged_mnemonic.dart';

import 'package:flutter/material.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/meaning_mnemonic.dart';

import 'form.dart';

class MnemonicsListBySubject extends StatefulWidget {
  const MnemonicsListBySubject({super.key, required this.subject});

  final Subject subject;

  @override
  State<MnemonicsListBySubject> createState() => _MnemonicsListBySubjectState();
}

class _MnemonicsListBySubjectState extends State<MnemonicsListBySubject> {
  late Future<List<dynamic>> _mnemonics;
  FormConfig _formConfig = FormConfig(editing: false);
  bool _showReadingMnemonic = false;

  @override
  void initState() {
    super.initState();

    _mnemonics = Api.fetchMeaningMnemonicsBySubject(
      widget.subject.id,
      context.read<User?>(),
    );
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

    if (user == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      await onUpdate(user);
      setState(() {
        _mnemonics =
            Api.fetchMeaningMnemonicsBySubject(widget.subject.id, user);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage),
        ),
      );
    }
  }

  void handleOnFormSubmit(String text) async {
    final mnemonic = _formConfig.mnemonic;

    setState(() {
      _formConfig = FormConfig(editing: false);
    });

    final user = context.read<User?>();

    if (user == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      if (mnemonic != null) {
        await Api.updateMeaningMnemonic(mnemonic.id, user, text);
      } else {
        await Api.createMeaningMnemonic(widget.subject, user, text);
      }
      setState(() {
        _mnemonics =
            Api.fetchMeaningMnemonicsBySubject(widget.subject.id, user);
      });
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
    final _ = context.watch<User?>();
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
            onSubmit: handleOnFormSubmit,
            defaultText: _formConfig.mnemonic?.text,
          );
        }

        if (_showReadingMnemonic) {
          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () => setState(() {
                          _showReadingMnemonic = false;
                        }),
                    icon: const Icon(Icons.close)),
              ),
              TaggedMnemonic(
                mnemonic: widget.subject.readingMnemonic,
                tags: const {Tag.ja, Tag.kanji, Tag.reading},
              ),
            ],
          );
        }

        return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (context.read<User?>() == null) {
                          Navigator.pushNamed(context, '/login');
                          return;
                        }

                        setState(() {
                          _formConfig = FormConfig(editing: true);
                        });
                      },
                      label: const Text('Add a mnemonic'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.record_voice_over_rounded),
                      onPressed: () {
                        setState(() {
                          _showReadingMnemonic = !_showReadingMnemonic;
                        });
                      },
                      label: const Text('Reading'),
                    ),
                  ],
                );
              }

              var mnemonic = data[index - 1];
              if (mnemonic is MeaningMnemonic) {
                final m = data[index - 1] as MeaningMnemonic;
                mnemonic = MeaningMnemonicWithUserInfo(
                    id: m.id,
                    text: m.text,
                    userId: m.userId,
                    votingCount: m.votingCount,
                    subject: widget.subject,
                    createdAt: m.createdAt,
                    updatedAt: m.updatedAt,
                    downvoted: false,
                    upvoted: false,
                    favorite: false,
                    me: false);
              } else {
                mnemonic = data[index - 1] as MeaningMnemonicWithUserInfo;
              }

              return MnemonicView(
                  mnemonic: mnemonic,
                  onOnUpvote: handleOnUpvote,
                  onOnDonwvote: handleOnDonwvote,
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
