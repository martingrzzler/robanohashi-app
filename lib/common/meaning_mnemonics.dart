import 'dart:math';
import 'package:provider/provider.dart';
import 'package:robanohashi/api/common.dart';
import 'package:robanohashi/api/subject_preview.dart';
import 'package:robanohashi/common/tagged_mnemonic.dart';
import 'package:robanohashi/service/auth.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/meaning_mnemonic.dart';

class MeaningMnemonics extends StatefulWidget {
  const MeaningMnemonics({
    super.key,
    required this.subject,
  });

  final Subject subject;

  @override
  State<MeaningMnemonics> createState() => _MeaningMnemonicsState();
}

class _MeaningMnemonicsState extends State<MeaningMnemonics> {
  bool _showForm = false;
  bool _loading = false;
  late Future<List<MeaningMnemonic>> _mnemonics;

  @override
  void initState() {
    super.initState();

    _mnemonics = Api.fetchMeaningMnemonics(widget.subject.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mnemonics,
      builder: (context, snapshot) {
        if (_showForm) {
          return MnemonicForm(
            onClose: () {
              setState(() {
                _showForm = false;
              });
            },
            onSubmit: (text) async {
              setState(() {
                _showForm = false;
              });
              final user = context.read<AuthService>().currentUser;

              if (user == null) {
                Navigator.pushNamed(context, '/login');
                return;
              }
              try {
                setState(() {
                  _loading = true;
                });
                await Api.createMeaningMnemonic(widget.subject, user, text);
                setState(() {
                  _mnemonics = Api.fetchMeaningMnemonics(widget.subject.id);
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to create mnemonic'),
                  ),
                );
              } finally {
                setState(() {
                  _loading = false;
                });
              }
            },
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting || _loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.error),
              SizedBox(width: 10),
              Text('Oops, something went wrong!'),
            ],
          ));
        }

        final data = snapshot.data as List<MeaningMnemonic>;

        return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (context.read<AuthService>().currentUser == null) {
                      Navigator.pushNamed(context, '/login');
                      return;
                    }

                    setState(() {
                      _showForm = true;
                    });
                  },
                  label: const Text('Add a mnemonic'),
                );
              }

              final mnemonic = data[index - 1];

              return Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.star_border)),
                      Row(children: [
                        Transform.rotate(
                          angle: pi / 2,
                          child: IconButton(
                            iconSize: 30,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.chevron_left,
                            ),
                          ),
                        ),
                        const Text('16'),
                        Transform.rotate(
                            angle: -pi / 2,
                            child: IconButton(
                                iconSize: 30,
                                onPressed: () {},
                                icon: const Icon(Icons.chevron_left)))
                      ]),
                      Expanded(
                        child: Container(),
                      ),
                      const Text(
                        'username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(
                          mnemonic.updatedAt * 1000))),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TaggedMnemonic(
                            mnemonic: mnemonic.text,
                            tags: const {
                              Tag.kanji,
                              Tag.radical,
                              Tag.vocabulary,
                              Tag.ja,
                            }),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              );
            });
      },
    );
  }
}

class MnemonicForm extends StatefulWidget {
  const MnemonicForm(
      {super.key, required this.onClose, required this.onSubmit});

  final Function onClose;
  final Function(String text) onSubmit;

  @override
  State<MnemonicForm> createState() => MnemonicFormState();
}

class MnemonicFormState extends State<MnemonicForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 40.0, top: 25),
              child: TextFormField(
                controller: _controller,
                maxLines: 50,
                autofocus: true,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                    hintText: 'The more absurd the better...'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
                color: Colors.transparent,
                child: IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit(_controller.text);
                      }
                    },
                    icon: const Icon(Icons.send))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                  onPressed: () => widget.onClose(),
                  icon: const Icon(Icons.close)),
            ),
          ),
        ],
      ),
    );
  }
}
